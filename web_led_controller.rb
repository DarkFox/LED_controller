require 'rubygems'
require 'sinatra'
require './led_controller.rb'

CONTROLLER = LedController.new("/dev/tty.usbmodemfd121")

get '/' do
  erb :'index.html'
end

get '/state' do
  CONTROLLER.current_state.to_json
end

get '/led' do
  if params[:mode]
    CONTROLLER.set_mode params[:mode]
    'OK'
  end

  if params[:h]
    CONTROLLER.set_h params[:h]
    'OK'
  end

  if params[:s]
    CONTROLLER.set_s params[:s]
    'OK'
  end

  if params[:l]
    CONTROLLER.set_l params[:l]
    'OK'
  end

  if params[:interval]
    CONTROLLER.set_interval params[:interval]
    'OK'
  end

  CONTROLLER.save
end