require "rubygems"
require "bundler"
Bundler.setup

require 'debugger'
require 'z3-core'
require 'builder'

root=Pathname.new(File.expand_path('../', File.dirname(__FILE__)))
$LOAD_PATH << root.join("app", "controllers").to_s
$LOAD_PATH << root.join("lib").to_s

require 'application_controller'
require 'z3_controller'
require root.join('config', 'goliath_app')
