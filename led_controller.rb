require 'rubygems'
require 'serialport'
require 'json'

class LedController
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
    send_serial_cmds [6, 1]
    state = @serial.readline
    JSON.parse(state)
  end

  def set_mode(mode)
    send_serial_cmds [1, mode.to_i]
  end

  def set_h(h)
    v1 = h.to_i / 255;
    v2 = h.to_i % 255;

    send_serial_cmds [2, v1, v2]
  end

  def set_s(s)
    send_serial_cmds [3, s.to_i]
  end

  def set_l(l)
    send_serial_cmds [4, l.to_i]
  end

  def set_interval(interval)
    v1 = interval.to_i / 255;
    v2 = interval.to_i % 255;
    send_serial_cmds [5, v1, v2]
  end

  private

  def send_serial_cmds(commands = [])
    # Clear out the buffer first.
    if @lock
      puts 'Serial interface locked'
      return false
    else
      @lock = true
      begin
        @serial.readlines
      rescue EOFError => e
      end
      commands.each do |command|
        @serial.write(command)
        begin
          @serial.readbyte
        rescue EOFError => e
          puts 'Giving up.'
          @lock = false
          return false
        end
      end
      @lock = false
      return true
    end
  end
end