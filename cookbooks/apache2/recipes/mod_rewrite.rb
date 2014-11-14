execute "a2enmod rewrite" do
  notifies :reload, 'service[apache2]', :delayed
end