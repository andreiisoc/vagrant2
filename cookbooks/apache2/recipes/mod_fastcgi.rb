package "libapache2-mod-fastcgi" do
  action :install
  notifies :reload, 'service[apache2]', :delayed
end

execute "a2enmod fastcgi" do
  notifies :reload, 'service[apache2]', :delayed
end