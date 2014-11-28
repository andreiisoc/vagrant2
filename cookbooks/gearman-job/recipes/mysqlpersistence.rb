package 'mysql-client-5.6 libmysqlclient-dev' do
  action :install
end

template "/etc/init/gearman-job-server.conf" do
  source 'upstart/gearman-job-server.conf.erb'
  mode   '0644'
  notifies :restart, "service[gearman-job-server]", :delayed 
end

template "/etc/default/gearman-job-server" do
  source 'gearman-job-server.erb'
  mode   '0644' 
  variables(:config => node['gearmanmysql'])
  action :create
  notifies :restart, "service[gearman-job-server]", :delayed 
end