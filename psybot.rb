require 'cinch'

#OPS = %w(vaz SyDy safiire Causai akhentek)

####
##  Bunch of responses for the bot when he hears a regex

class Fortune
  include Cinch::Plugin

  match "fortune"

  def execute(m)
    m.reply `fortune`
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = ["#PsytranceMessiah"]
    c.nick = ENV['NICK'] || "Psykachu"
    c.plugins.plugins = [Fortune]
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped? m.user
  end

  on :message, /psytrance/i do |m|
     m.reply("Psytrance is bad music, #{m.user.nick}")
  end

  on :message, /ya+y/i do |m|
    m.reply("Yaaaaaaaaaaay!")
    m.action_reply("explodes!")
  end

end

bot.start
