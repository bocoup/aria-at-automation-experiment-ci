Vagrant.configure('2') do |config|
  config.vm.box = 'https://ewr1.vultrobjects.com/boxes/package.box'

  # Assign a stable name to the virtual machine so that it can be referenced in
  # calls to AssistiveWebdriver
  config.vm.provider :virtualbox do |vb|
    vb.name = 'vagrant-macos-1015'
  end
end
