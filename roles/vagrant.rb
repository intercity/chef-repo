name 'vagrant'
description 'A few settings to make the recipes work when using Vagrant'
default_attributes(:bluepill => {:bin => "/opt/vagrant_ruby/bin/bluepill"})
run_list "recipe[vagrant]"