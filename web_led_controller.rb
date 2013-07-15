require 'rubygems'
require "sinatra/base"
require File.expand_path '../led_controller.rb', __FILE__

set :bind, '0.0.0.0'

class FakeController
  def method_missing(meth, *args, &block)
    return true
  end
end

#CONTROLLER = LedController.new("/dev/tty.usbmodemfd121")
CONTROLLER = FakeController.new


class WebLedController < Sinatra::Base
  get '/' do
    erb :'index.html'
  end

  get '/state' do
    [200,{"Content-Type" => "text/json"}, [CONTROLLER.current_state.to_json]]
  end

  get '/led' do

    # Modes
    # 0: OFF
    # 1: ON
    # 2: Pulse
    # 3: Random fade
    # 4: Rainbow fade
    # 5: Strobe
    # 6: Sleep
    # 7: Direct
    if params[:mode]
      CONTROLLER.set_mode params[:mode]
      [200,{"Content-Type" => "text/plain"}, ["OK"]]
    end

    # Hue
    # 0-360
    if params[:hue]
      CONTROLLER.set_hue params[:hue]
      [200,{"Content-Type" => "text/plain"}, ["OK"]]
    end

    # Saturation
    # 0-255
    if params[:sat]
      CONTROLLER.set_sat params[:sat]
      [200,{"Content-Type" => "text/plain"}, ["OK"]]
    end

    # Luminosity
    # 0-255
    if params[:lum]
      CONTROLLER.set_lum params[:lum]
      [200,{"Content-Type" => "text/plain"}, ["OK"]]
    end

    # Interval
    # 0-2048
    if params[:interval]
      CONTROLLER.set_interval params[:interval]
      [200,{"Content-Type" => "text/plain"}, ["OK"]]
    end

    CONTROLLER.save
  end
end