require 'cinch'

#OPS = %w(vaz SyDy safiire Causai akhentek)

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = ["#PsytranceMessiah"]
    c.nick = ENV['NICK'] || "psybot"
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped? m.user
  end

  on :message, /psytrance/ do |m|
    m.reply "psytrance is bad music, #{m.user.nick}"
  end
end

bot.start
