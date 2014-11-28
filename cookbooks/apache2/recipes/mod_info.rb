template "/etc/apache2/mods-available/info.conf" do
  source '/mods/info.conf.erb'
  mode   '0644' 
  notifies :reload, "service[apache2]", :delayed 
end

execute "a2enmod info" do
  notifies :reload, 'service[apache2]', :delayed
end