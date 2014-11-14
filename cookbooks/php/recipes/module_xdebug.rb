package 'php5-xdebug' do
  action :install
  notifies :reload, 'service[apache2]', :delayed 
end
