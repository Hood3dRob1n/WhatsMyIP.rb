#!/usr/bin/env ruby
#
# Find IP using simple query to DYNDNS.org & Internal facing interface
#

require 'ipaddr'
require 'net/http'
require 'socket'
require 'rubygems'
require 'colorize'

def getLocal
	orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  #RevDNS = Off, so dont resolve!
	 
	UDPSocket.open do |sox|
		sox.connect '74.125.227.32', 1 #this is Google, but we dont actually send anything, just looking for how machine would if we did :p
		sox.addr.last
	end
	rescue SocketError => e # sox shit happens?
        	puts "Socket Error!".light_red
		puts "\t=> #{e}".light_red
	ensure
		Socket.do_not_reverse_lookup = orig
end

#Simply fetch the external from dyndns, not so much magic :p
def getExternal
	dyn = Net::HTTP.new('checkip.dyndns.org', 80)
	resp,body = dyn.get("/")
	ip = body.match(/\d+\.\d+\.\d+\.\d+/)
	ip[0]
end

external = IPAddr.new(getExternal)
puts
puts "External IP: ".white + "#{external}".light_green
puts "Internal IP: ".white + "#{getLocal}".light_green
puts
#EOF

