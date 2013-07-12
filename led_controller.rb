require 'rubygems'
require 'serialport'
require 'json'

class LedController
  # Maximum stable rate of commands seems to be around 55.6 Hz (Or 18 ms between each command) in direct serial mode.

  @lock = false
  @serial = nil

  attr_accessor :serial, :lock

  def initialize(port_str)
    baud_rate = 9600
    data_bits = 8
    stop_bits = 1
    parity = SerialPort::NONE

    @serial = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
    @serial.read_timeout = 100
  end

  def current_state
    # Flush buffer first
    @serial.readline
    send_cmd "STATE"
    state = @serial.readline
    JSON.parse(state)
  end

  def set_mode(mode)
    send_cmd "MODE #{mode.to_i}"
  end

  def set_hue(hue)
    send_cmd "HUE #{hue.to_i}"
  end

  def set_sat(sat)
    send_cmd "SAT #{sat.to_i}"
  end

  def set_lum(lum)
    send_cmd "LUM #{lum.to_i}"
  end

  def write_hsl
    send_cmd "WRITEHSL"
  end

  def set_hsl(h, s, l)
    send_cmd "SETHSL #{h.to_i} #{s.to_i} #{l.to_i}"
  end

  def set_interval(interval)
    send_cmd "INTERVAL #{interval.to_i}"
  end

  def set_red(pwr)
    send_cmd "RED #{pwr.to_i}"
  end

  def set_grn(pwr)
    send_cmd "GRN #{pwr.to_i}"
  end

  def set_blu(pwr)
    send_cmd "BLU #{pwr.to_i}"
  end

  def write_rgb
    send_cmd "WRITERGB"
  end

  def set_rgb(r, g, b)
    send_cmd "SETRGB #{r.to_i} #{g.to_i} #{b.to_i}"
  end

  def save
    send_cmd "SAVE"
  end

  private

  def send_cmd(command)
    @serial.write(command+"\n")
  end
end