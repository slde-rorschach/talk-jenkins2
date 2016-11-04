# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

settings = YAML.load_file 'config.yml'

Vagrant.configure("2") do |config|
    config.vm.box       = settings['box']['name']
    config.vm.host_name = settings['hostname']

    config.vm.network "private_network", ip: settings['box']['ip']
    config.vm.synced_folder settings['box']['share']['host'], 
        settings['box']['share']['guest'], 
        id: "vagrant-share", 
        :nfs => settings['box']['share']['nfs']

    config.vm.provision "ansible_local" do |ansible|
        ansible.provisioning_path = settings['box']['share']['guest']
        ansible.playbook          = settings['playbook']
    end
end
