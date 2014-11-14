package 'php5-phalcon' do
  action :install
  notifies :reload, 'service[apache2]', :delayed 
end
