N_MACHINES=2
IP_PREFIX = '192.168.35'
IP_PREFIX_SEC = '192.168.34'
IP_SUFFIX_BASE = 10

def ip_addr(i)
  "#{IP_PREFIX}.#{IP_SUFFIX_BASE + i}"
end

def ip_addr_sec(i)
  "#{IP_PREFIX_SEC}.#{IP_SUFFIX_BASE + i}"
end

def hostname(i)
  "cilium#{i}"
end

public_key_path = File.join(Dir.home, ".ssh", "id_rsa.pub")
if File.exist?(public_key_path)
  public_key = IO.read(public_key_path)
end

# Test machines
Vagrant.configure(2) do |config|
    (1..N_MACHINES).each do |i|
        hostname = hostname(i)
        config.vm.define hostname do |host|
            host.vm.provider "virtualbox" do |vb|
                vb.name = hostname
                vb.memory = 4096
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
                vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
            end

            host.vm.box = "cilium/ubuntu-next"
            host.vm.box_version = "86"
            host.vm.hostname = hostname
            host.vm.network "private_network", ip: ip_addr(i)
            host.vm.network "private_network", ip: ip_addr_sec(i)
            host.vm.synced_folder ".", "/vagrant", disabled: true
            host.vm.synced_folder "/Users/jussi/work/github.com/cilium/cilium", "/cilium", type: "nfs", nfs_udp: false
        end
    end
    config.ssh.forward_agent = true
    config.ssh.keys_only = false
    config.vm.provision "shell", path: "provision.sh"
    config.vm.provision "shell", path: "dotfiles.sh", privileged: false
    config.vm.provision :shell, privileged: false, :inline => <<-SCRIPT
      set -e
      echo '#{public_key}' >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
    SCRIPT
end
