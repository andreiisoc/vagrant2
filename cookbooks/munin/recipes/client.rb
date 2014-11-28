package "munin-node" do
  action :install
end

package "libwww-perl" do
  action :install
end

package "munin-plugins-extra" do
  action :install
end

service "munin-node" do
  #service_name "munin-node"
  #provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :restart => true, :stop => true
  action [ :enable, :start ]
  restart_command "sudo service munin-node stop && sudo /etc/init.d/munin-node restart && sudo service munin-node start"
end

template "/etc/munin/munin-node.conf" do
  source 'munin-node.conf.erb'
  mode   '0644' 
  variables(
    :munin_nodes => node['munin']['nodes']
  )
  notifies :restart, "service[munin-node]", :delayed
end

execute "install mysql mod dependency" do
  command "apt-get install libcache-cache-perl -y"
  action :run
  only_if { ::File.exists?("/etc/mysql/my.cnf")}
end

execute "install suggested modules" do
  command "sudo /usr/sbin/munin-node-configure --shell | sudo sh"
  action :run
  notifies :restart, "service[munin-node]", :delayed
end