#package 'php5-phalcon' do
#  action :install
#  notifies :reload, 'service[apache2]', :delayed 
#end

apt_repository 'php5-phalcon' do
  uri          'ppa:phalcon/stable'
  distribution node['lsb']['codename']
end

apt_package "php5-phalcon" do
  action :install
  notifies :reload, 'service[apache2]', :delayed
end