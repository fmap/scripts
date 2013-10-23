#!/usr/bin/env ruby

class Interface
  attr_accessor :interface

  def initialize interface
    self.interface = interface
  end

  def MAC
    re = /(?:[a-f0-9]{2}:){5}[a-f0-9]{2}/i
    %x|ifconfig #{interface}|[re]
  end

  def MAC=address
    system "ifconfig #{interface} down"
    system "ifconfig #{interface} hw ether #{address} up"
  end
end

class MAC
  def self.rand
    (1..6).collect { Kernel.rand(256).to_s(16).rjust(2,?0) }.join(?:)
  end
end

interface = Interface.new('wlp2s0')
print "#{interface.MAC} => "
interface.MAC = MAC.rand
puts interface.MAC
