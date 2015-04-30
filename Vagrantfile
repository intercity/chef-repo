# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.omnibus.chef_version = :latest

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/ubuntu-14.04"
  # config.vm.box = "chef/ubuntu-12.04"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.librarian_chef.cheffile_dir = "./"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #
  config.vm.define "postgresql" do
    config.vm.network :forwarded_port, guest: 80, host: 8080
  end

  config.vm.define "mysql" do
    config.vm.network :forwarded_port, guest: 80, host: 8081
    config.vm.network :forwarded_port, guest: 443, host: 4431
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../intercity-chef-repo", "/intercity-chef-repo"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", 2]
  end

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  json_payload = {
    "authorization" => {
      "sudo" => {
        "passwordless" => true,
        "users" => ["vagrant"]
      }
    },
    "apt" => {
      "unattended_upgrades" => {
        "enabled" => true
      }
    },
    "mysql" => {
      "server_debian_password" => "a",
      "server_repl_password" => "a",
      "server_root_password" => "a"
    },
    "postgresql" => {
      "password" => {
        "postgres" => "a"
      }
    },
    "active_applications" => {
      "intercity_sample_app" => {
        ruby_version: "2.2.2",
        domain_names: ["localhost"],
        packages: ["nodejs"],
        rails_env: "staging",
        "database_info" => {
          host: "localhost",
          username: "a",
          password: "b",
          database: "intercity_sample_app_production"
        },
        "env_vars" => {
          "SECRET_KEY_BASE" => "5c11bffd8ad6d537fc291c4b4089a42a2f40ee6869d75490eef944196b3b601053a8d9c2f5c29aa8738fa786f5c14dd5a6fab1b5537095c2c5ed3f2567392463"
        },
        "nginx_custom" => {
          "before_server" => "server {
              server_name www.localhost;
              return 301 $scheme://localhost:8081$request_uri;
            }"
        }
      }
    },
    "ssh_deploy_keys" => [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuiCTIYcGAbNemW4e1Q0SqfweN2d1Tkhn6xtwiV6/AITgSaW5bFWo/VEUghlCYwYcBgxoOMy0jfUJLS/XG/nQUsL3MKI/oAoFiaVoyDPb/zPvYeWrp3eGi+Ey66luVEVWLdHe1RQqCA52j5mSSCYsjKWt+q8eZWADASyuBsrIZjkdQ8z3ziSeaJdTXPKBKyMPAHd26JFZoBQL39OYcq6xozM7B+IlBoLJhFQRZP1IFjWJYtdYTj2PoByDynfZKltWgS/ouDNIzPhF9ZubXSrwYR4uCXmQbdk+quBItw/RJW7rIlLua24yhoPA/STNel/8Ld33FhMV8D0bx6mj+BrqV michiel@MacBook-Air-van-Michiel.local",
"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArzYY9umFYiWoKL8scmB65Tui+QpZwpgQJENUXVIo6NnVwdaIkJTYUrDrHpAb/8NzPdVFz517qoyerFzHnLjjokhX5Nf0h5QL4GTcvajzKBsvXlGjad8ILo34nTjMpVDlYkBBOGcZ8mz7+1+KIQo7vWllcyQqEg3Sddrk0UA55U85IOgQuzRSvd8gXbEC42ghlALfnPEGgCLiUIj5koiIPU3cooa7SH3WiE6jtkt+aoeWqlzxqykS6l1JqJUkeqgobBUtM3H0uyXx8+TtqsM8Zo/Y8zYOy2u+ndIbLILp47dxi/l9IKVKrRhK4eW8yz6/yVsuDZ6YrxAV4GeYYx1pgQ== michiel@iMac-van-Michiel-Sikkes.local"
    ],
  }

  config.vm.define "postgresql" do

    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.roles_path = "./roles"

      chef.add_role "postgresql"
      chef.add_role "rails_passenger"

      chef.log_level = :info

      if json_payload["active_applications"].size > 0
        json_payload["active_applications"]["intercity_sample_app"]["database_info"]["adapter"] = "postgresql"
      end

      # You may also specify custom JSON attributes:
      chef.json = json_payload
    end

  end

  config.vm.define "mysql" do

    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.roles_path = "./roles"

      chef.add_role "mysql"
      chef.add_role "rails"

      chef.log_level = :info

      if json_payload["active_applications"].size > 0
        json_payload["active_applications"]["intercity_sample_app"]["database_info"]["adapter"] = "mysql2"
      end

      # You may also specify custom JSON attributes:
      chef.json = json_payload
    end

  end

end
