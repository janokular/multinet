Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  
  config.vm.define "server01" do |server01|
    server01.vm.hostname = "server01"
    server01.vm.network "private_network", ip: "10.9.8.11"
    server01.vm.provision "shell", path: "server-setup.sh"
  end

  config.vm.define "server02" do |server02|
    server02.vm.hostname = "server02"
    server02.vm.network "private_network", ip: "10.9.8.12"
    server02.vm.provision "shell", path: "server-setup.sh"
  end

  config.vm.define "admin01" do |admin01|
    admin01.vm.hostname = "admin01"
    admin01.vm.network "private_network", ip: "10.9.8.10"
    admin01.vm.provision "shell", path: "client-setup.sh"
  end
end
