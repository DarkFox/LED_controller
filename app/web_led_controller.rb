require 'rubygems'
require "sinatra/base"
require File.expand_path '../led_controller.rb', __FILE__

class FakeController
  def current_state
    {mode: 1, hue: 64, lum: 128, sat: 255, interval: 500}
  end

  def method_missing(meth, *args, &block)
    return true
  end
end

#CONTROLLER = LedController.new("/dev/tty.usbmodemfd121")
CONTROLLER = FakeController.new


class WebLedController < Sinatra::Base
  set :bind, '0.0.0.0'

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
    CONTROLLER.set_mode params[:mode] if params[:mode]

    # Hue
    # 0-360
    CONTROLLER.set_hue params[:hue] if params[:hue]

    # Saturation
    # 0-255
    CONTROLLER.set_sat params[:sat] if params[:sat]

    # Luminosity
    # 0-255
    CONTROLLER.set_lum params[:lum] if params[:lum]

    # Interval
    # 0-2048
    CONTROLLER.set_interval params[:interval] if params[:interval]

    'OK'
  end

  get '/save' do
    CONTROLLER.save

    'OK'
  end
end
