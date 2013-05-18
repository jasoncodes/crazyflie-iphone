# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project/template/ios'

def find_provisioning_profile(name)
  candidates = Dir["/Users/#{ENV['USER']}/Library/MobileDevice/Provisioning Profiles/*.mobileprovision"].select do |path|
    File.read(path).include? "<string>#{name}</string>"
  end
  unless candidates.size == 1
    raise "Could not find #{name.inspect} provisioning profile"
  end
  candidates.first
end

Motion::Project::App.setup do |app|
  app.name = 'Crazyflie'
  app.interface_orientations = [:landscape_left, :landscape_right]

  app.version = '0' # build number
  app.info_plist['CFBundleShortVersionString'] = '0.0.0'

  app.development do
    app.identifier = 'com.jasoncodes.crazyflie.dev'
    app.provisioning_profile = find_provisioning_profile('Xcode: Wildcard AppID')
  end
end
