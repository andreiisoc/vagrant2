package "supervisor" do
  action :install
end

service "supervisor" do
  #provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/supervisor/supervisord.conf" do
  source 'supervisord.conf.erb'
  mode   '0644'
  variables(
  	:config => node['supervisor']
  	)
  action :create
  notifies :restart, "service[supervisor]", :delayed 
end

execute "Deleting workers ... " do
    command "find -regex '.*conf$' -delete"
    cwd "/etc/supervisor/conf.d"
    action :run
    notifies :restart, "service[supervisor]", :delayed 
end

if node['supervisor']['processes'].count > 0
	node['supervisor']['processes'].each do |process|

		template "/etc/supervisor/conf.d/#{process['name']}.conf" do
			source 'program.conf.erb'
		  variables(
		  	:config => process
		  	)
		  action :create
		  notifies :restart, "service[supervisor]", :delayed 
		end

	end
end