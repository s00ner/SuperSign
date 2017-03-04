#!/usr/bin/env ruby
require 'rufus-scheduler'

#This code is a modified version of code that used to communicate with a LED Sign.
#Anything that doesn't make sense is probably due to that.
class SignHandler
  def initialize(default_message)
    @messages = Hash.new
    @colors = {
      red: "<CB>",
      orange: "<CD>",
      yellow: "<CG>",
      green: "<CM>",
      rainbow: "<CP>"
    }
    @scheduler = Rufus::Scheduler.new
    @default = default_message
    update
  end

  attr_reader :messages

  #function to add a new message to the sign
  def add(uuid, message, color = nil, timer = nil, default = false)
    color ||= :red
    timer ||= '30m'
    @messages[uuid] = {
      message: message,
      color: color,
      timer: timer
    }
    @scheduler.in timer do
      self.delete(uuid)
    end
    #below we check to see if we're setting the default message to avoid a recursive loop
    return update unless default == true #update will return false if message length is too long
  end

  #deletes message with number uuid from the sign
  def delete(uuid)
    @messages.delete(uuid)
    update
  end

  #clears all messages from the sign
  def reset
    @messages.clear
    update
  end

  private
  def update
    if @messages == {}
      self.add(1,@default,nil,nil,true)
    else
      @messages.delete(1)
    end
		return @messages
    end
  end

puts "this is a test"


=begin
uas_sign = SignHandler.new("/dev/ttyUSB0")
uas_sign.add(1,"red ", :red, :none)
uas_sign.add(2,"orange ", :orange, :none)
uas_sign.add(3,"green ", :green, :none)
uas_sign.add(4,"yellow ", :yellow, :none)
uas_sign.add(5,"rainbow", :rainbow, :none)


=begin
text = "start: "
while uas_sign.add(1, text, :yellow, :none)
  text = text + "123456789test  1234123412341234123412341234"
  puts text.length
  sleep(9)
end
=begin
for i in 0..5
  uas_sign.add(42, "8======D", :rainbow, :none)
  sleep(5)
  uas_sign.add(42, "this is a test", :green, :none)
  sleep(5)
end

uas_sign.reset
=end
