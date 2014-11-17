template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
      :hosts => node['hostnames']['definitions'],
      :hostname => node[:hostname],
      :fqdn => node[:fqdn]
  )
end