template "/etc/apache2/mods-available/status.conf" do
  source '/mods/status.conf.erb'
  mode   '0644' 
  notifies :reload, "service[apache2]", :delayed 
end