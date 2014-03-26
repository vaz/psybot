require 'bundler/setup'
require 'cinch'

require_relative 'plugins/fortune'
require_relative 'plugins/say'
require_relative 'plugins/reload'
require_relative 'plugins/ekto'


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
    c.plugins.plugins = [Fortune, Say, Reload, Ekto]
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped?(m.user) || m.user == @bot
  end

  respond_to(/psy[ -]?trance/i) do |m|
    m.reply "Psytrance is bad music, #{m.user.nick}"
  end

  respond_to(/spytrance/i) do |m|
    m.reply ("Spytrance is good music, unlike that psytrance that we all hate.")
  end

  respond_to(/ya+y/i) do |m|
    m.reply("Yaaaaaaaaaaay!")
    m.action_reply("explodes!")
  end

  respond_to(/hi(gh)?[ -]?tech/i) do |m|
    m.reply "Hi-tech isn't psytrance."
  end

  respond_to(/#{NICK}/i) do |m|
    m.action_reply "looks at #{m.user.nick} excitedly!"
  end

end

bot.start
