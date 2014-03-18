require 'cinch'

require_relative 'plugins/fortune'
require_relative 'plugins/say'
require_relative 'plugins/reload'


CHANNEL = ENV['CHANNEL'] || '#PsytranceMessiah'
NICK = ENV['NICK'] || 'psykachu'


module Cinch::Respond
  def respond_to(pattern)
    on(:message, pattern) { |m| yield m unless m.user.user == '~cinch' }
  end
end

bot = Cinch::Bot.new do
  extend Cinch::Respond

  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = [CHANNEL]
    c.nick = NICK
    c.plugins.plugins = [Fortune, Say, Reload]
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped? m.user
  end

  respond_to(/psy[ -]?trance/i) do |m|
    m.reply "Psytrance is bad music, #{m.user.nick}"
  end

  respond_to(/ya+y/i) do |m|
    m.reply("Yaaaaaaaaaaay!")
    m.action_reply("explodes!")
  end

  respond_to(/hi(gh)?[ -]?tech/i) do |m|
    m.reply "Hi-tech isn't psytrance."
  end

end

bot.start
