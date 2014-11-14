package "munin" do
  action :install
end

template "/etc/munin/apache.conf" do
  source 'apache.conf.erb'
  mode   '0644' 
  notifies :restart, "service[munin-node]", :delayed 
end

template "/etc/munin/munin.conf" do
  source 'munin.conf.erb'
  mode   '0644' 
  variables(
    :munin_nodes => node['munin']['nodes']
  )
  notifies :restart, "service[munin-node]", :delayed 
end