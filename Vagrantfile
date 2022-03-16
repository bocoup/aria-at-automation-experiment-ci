Vagrant.configure('2') do |config|
  config.vm.box = 'assistive-webdriver/win10-chromium-nvda'

  # Assign a stable name to the virtual machine so that it can be referenced in
  # calls to AssistiveWebdriver
  config.vm.provider :virtualbox do |vb|
    vb.name = 'win10-chromium-nvda'
  end
end
