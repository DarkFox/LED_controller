require "rubygems"
require "sinatra"

require File.expand_path '../app/web_led_controller.rb', __FILE__

run WebLedController
