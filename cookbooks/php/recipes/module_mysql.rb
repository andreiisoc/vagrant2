package 'php5-mysql' do
  action :install
  notifies :reload, 'service[apache2]', :delayed 
end
