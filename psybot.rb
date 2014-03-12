require 'cinch'

OPS = ["vaz", "SyDy"]

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = ["#PsytranceMessiah"]
    c.nick = "psybot"
  end

  on :join do |m|
    if OPS.include?(m.user.nick)
      m.channel.op(m.user)
    end
  end
end

bot.start
