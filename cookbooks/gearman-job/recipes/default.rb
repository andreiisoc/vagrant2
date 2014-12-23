package "gearman-job-server" do
  action :install
end

package "gearman-tools" do
  action :install
end

service "gearman-job-server" do
  #provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :restart => true, :reload => true
  action [ :enable, :start ]
  restart_command "sudo service gearman-job-server restart"
  status_command "sudo service gearman-job-server status"
  start_command "sudo service  gearman-job-server stop && sudo service gearman-job-server start"
end