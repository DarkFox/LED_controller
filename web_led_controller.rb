require 'rubygems'
require "sinatra/base"
require File.expand_path '../led_controller.rb', __FILE__

CONTROLLER = LedController.new("/dev/tty.usbmodemfd121")

class WebLedController < Sinatra::Base
  get '/' do
    erb :'index.html'
  end

  get '/state' do
    CONTROLLER.current_state.to_json
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
      'OK'
    end

    # Hue
    # 0-360
    if params[:hue]
      CONTROLLER.set_hue params[:hue]
      'OK'
    end

    # Saturation
    # 0-255
    if params[:sat]
      CONTROLLER.set_sat params[:sat]
      'OK'
    end

    # Luminosity
    # 0-255
    if params[:lum]
      CONTROLLER.set_lum params[:lum]
      'OK'
    end

    # Interval
    # 0-2048
    if params[:interval]
      CONTROLLER.set_interval params[:interval]
      'OK'
    end

    CONTROLLER.save
  end
end