apt_repository 'php5-phalcon' do
  uri          'ppa:phalcon/stable'
  distribution node['lsb']['codename']
end

apt_package "php5-phalcon" do
  action :install
  notifies :reload, 'service[apache2]', :delayed
end

if node.chef_environment == "dev"
	include_recipe "composer"

	directory '/etc/phalcon-devtools' do
  	action :create
	end

	template "/etc/phalcon-devtools/composer.json" do
  	source 'phalcon_devtools_composer.json.erb'
  	
  	action :create
  	notifies :run, 'execute[execute composer install]', :immediately
	end

	execute 'execute composer install' do
		cwd '/etc/phalcon-devtools'
	  command "composer install"
	  action :run
	end

	link "phalcon" do
		target_file "/usr/bin/phalcon"
		to "/etc/phalcon-devtools/vendor/phalcon/devtools/phalcon.php"
		link_type :symbolic 

		action :create
	end
end