# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/osx"
require "rubygems"
require "motion-cocoapods"
require "motion-facon"
require "teacup"

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "Travis"

  # Don't create a dock icon for the app
  app.info_plist["LSUIElement"] = true

  app.pods do
    pod "DBPrefsWindowController"
    pod "AFNetworking"
  end
end
