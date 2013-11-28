Vagrant.configure("2") do |config|
  config.vm.hostname = "rbenv-berkshelf"
  config.vm.box      = "Berkshelf-CentOS-6.3-x86_64-minimal"
  config.vm.box_url  = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"

  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network :forwarded_port, guest: 8081, host: 8081
  config.vm.network :forwarded_port, guest: 8443, host: 8443

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :rbenv => {
        :group_users => ["vagrant"]
      }
    }

    chef.run_list = [
      "recipe[rbenv::default]",
      "recipe[rbenv::ruby_build]"
    ]
  end
end
