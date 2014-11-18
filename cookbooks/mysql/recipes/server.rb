package 'mysql-server-5.6' do
  action :install
end

service "mysql" do
  #service_name "mysql"
  #provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :restart => true, :stop => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/mysql/my.cnf" do
  source 'my.cnf.erb'
  mode   '0644' 
  notifies :restart, "service[mysql]", :delayed 
end

require 'shellwords'

execute 'assign-root-password' do
  cmd = "/usr/bin/mysqladmin"
  cmd << ' -u root password '
  cmd << node['mysql']['server_root_password']
  command cmd
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template '/etc/mysql_grants.sql' do
  cookbook 'mysql'
  source 'grants.sql.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(:config => node['mysql'])
  action :create
  notifies :run, 'execute[install-grants]'
end

execute 'install-grants' do
  cmd = "/usr/bin/mysql"
  cmd << ' -u root '
  cmd << "#{pass_string} < /etc/mysql_grants.sql"
  command cmd
  action :nothing
  notifies :run, 'execute[create root marker]'
end

execute 'create root marker' do
  cmd = '/bin/echo'
  cmd << " '#{Shellwords.escape(node['mysql']['server_root_password'])}'" 
  cmd << ' > /etc/.mysql_root'
  cmd << ' ;/bin/chmod 0600 /etc/.mysql_root'
  command cmd
  action :nothing
  notifies :restart, "service[mysql]", :delayed
end