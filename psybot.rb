require 'cinch'

#OPS = %w(vaz SyDy safiire Causai akhentek)

####
##  Bunch of responses for the bot when he hears a regex

class Psytrance
  include Cinch::Plugin

end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = ["#PsytranceMessiah"]
    c.nick = ENV['NICK'] || "GiR"
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped? m.user
  end

  on :message, /psytrance/i do |m|
    m.reply("Psytrance is bad music")
  end

end

bot.start
