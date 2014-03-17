require 'cinch'


CHANNEL = ENV['CHANNEL'] || '#PsytranceMessiah'
NICK = ENV['NICK'] || 'psykachu'


class Fortune
  include Cinch::Plugin

  match "fortune"

  def execute(m)
    m.reply `fortune`
  end
end

class Say
  include Cinch::Plugin

  match(/say (.+)/)

  def execute(m, message)
    Channel(CHANNEL).send(message)
  end
end

class Reload
  include Cinch::Plugin

  match(/reload/)
  listen_to(:join, method: :joined)

  def execute(m)
    @bot.nick += '_reloading'
    system "git pull"
    spawn "NICK='#{NICK}' CHANNEL='#{CHANNEL}' ruby #{$0}"
    @reloading = true
  end

  def joined(m)
    if @reloading && m.user.nick == NICK
      @bot.quit 'I have become obsolete, goodbye.'
    end
  end
end

RESPONSES = {
  /psy[ -]?trance/i => lambda do |m|
    m.reply "Psytrance is bad music, #{m.user.nick}"
  end,

  /ya+y/i => lambda do |m|
    m.reply("Yaaaaaaaaaaay!")
    m.action_reply("explodes!")
  end,

  /hi(gh)?[ -]?tech/i => lambda do |m|
    m.reply "Hi-tech isn't psytrance."
  end
}

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = [CHANNEL]
    c.nick = NICK
    c.plugins.plugins = [Fortune, Say, Reload]
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped? m.user
  end

  RESPONSES.each do |p, f|
    on(:message, p) { |m| fm[m] unless m.user.user == '~cinch' }
  end

end

bot.start
