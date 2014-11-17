# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#maximim number of HTTP servers
MAX_HTTP_SERVERS = 2

#ip addresses settings
ips = {
  "lb" => {"name"=>"lb", "host"=>"lb.dev", "ipaddress"=>"10.66.66.100"},
  "db" => {"name"=>"db", "host"=>"db.dev", "ipaddress"=>"10.66.66.120"}
}

(1..MAX_HTTP_SERVERS).each do |i|
  ips["web#{i}"] = {"name"=>"web#{i}", "host"=>"web#{i}.dev", 'ipaddress'=>"10.66.66.11#{i}"}
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  #general provisioning of all instances
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "hostnames"

      nodes_hosts_file = []

      ips.each do |key, value|
        nodes_hosts_file.push ['hostname'=>value["host"], "ipaddress"=>value["ipaddress"]]
      end

      chef.json = {
        :hostnames => {
          :definitions => nodes_hosts_file
        }
      }
  end
  
  #load balancer
  config.vm.define "lb" do |lb|
    lb.vm.provider "virtualbox" do |v|
      v.name = ips["lb"]["name"]
    end
  
    lb.vm.hostname = ips["lb"]["host"]
    lb.vm.network "private_network", ip: ips["lb"]["ipaddress"]

    lb.vm.provision :chef_solo do |chef|
      chef.add_recipe "apache2"
      chef.add_recipe "apache2::mod_rewrite"
      chef.add_recipe "apache2::mod_fastcgi"
      chef.add_recipe "munin::client"
      chef.add_recipe "munin::server"
      chef.add_recipe "haproxy"

      haproxy_backend_servers = []

      (1..MAX_HTTP_SERVERS).each do |i|
        haproxy_backend_servers.push "server " + ips["web#{i}"]["name"] + " " + ips["web#{i}"]["ipaddress"] + ":80 weight 1 maxconn 100 check"
      end

      munin_nodes = []

      ips.each do |key, value|
        munin_nodes.push ['fqdn'=>value["host"], "ipaddress"=>value["ipaddress"]]
      end
    
      chef.json = {
        :apache => {
          :listen_port => 8080
        },
        :munin => {
          :nodes => munin_nodes
        },
        :haproxy => { 
          :admin => {
            :address_bind => ips["lb"]["ipaddress"]
          },
          :listeners => {
            :frontend => {
              :http => [
                "maxconn 2000",
                "bind *:80",
                "default_backend servers-http"
              ]
            },
            :backend => {
              "servers-http" => haproxy_backend_servers
            }
          }
        }
      }
    end

  end

  #web servers
  (1..MAX_HTTP_SERVERS).each do |i|

    config.vm.define "web#{i}" do |web|

      web.vm.provider "virtualbox" do |v|
        v.name = ips["web#{i}"]["name"]
      end

      web.vm.hostname = ips["web#{i}"]["host"]
      web.vm.network "private_network", ip: ips["web#{i}"]["ipaddress"]
      web.vm.synced_folder "html/", "/var/www/html", :owner => "vagrant", :group => "www-data", :mount_options => ["dmode=750","fmode=644"]

      web.vm.provision :chef_solo do |chef|
        chef.add_recipe "apache2"
        chef.add_recipe "apache2::mod_rewrite"
        chef.add_recipe "apache2::mod_fastcgi"
        chef.add_recipe "apache2::mod_php5"
        chef.add_recipe "php"
        chef.add_recipe "php::module_mysql"
        chef.add_recipe "php::module_xdebug"
        chef.add_recipe "php::module_phalcon"
        chef.add_recipe "munin::client"
      
        chef.json = {
          :munin => {
            :nodes => [
              ['fqdn'=>ips["lb"]["host"], 'ipaddress'=>ips["lb"]["ipaddress"]]
            ]
          }
        }
      end

    end

  end
  
  #database server
  config.vm.define "db" do |db|

    db.vm.provider "virtualbox" do |v|
      v.name = ips["db"]["name"]
    end
  
    db.vm.hostname = ips["db"]["host"]
    db.vm.network "private_network", ip: ips["db"]["ipaddress"]
  
    db.vm.provision :chef_solo do |chef|
      chef.add_recipe "mysql::client"
      chef.add_recipe "mysql::server"
      chef.add_recipe "munin::client"
    
      chef.json = {
        :mysql => {
          :server_root_password => '123456',
          :allow_remote_root => true
        },
        :munin => {
          :nodes => [
            ['fqdn'=>ips["lb"]["host"], 'ipaddress'=>ips["lb"]["ipaddress"]]
          ]
        }
      }
    end

  end
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "default.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { mysql_password: "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end