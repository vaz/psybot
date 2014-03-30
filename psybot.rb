require 'bundler/setup'
require 'cinch'
require 'cinch/plugins/urbandictionary'
require 'cinch/plugins/haiku'
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


module Cinch::FiendyGreet

  @drug_classes ||= %w(
    deliriants
    psychedelics
    uppers
    downers
    benzos
    dissociatives
    NMDA_antagonists
    amphetamines
    bath_salts
    anticholinergics
    entheogens
    arylcyclohexylamines
  ).map! do |drug|
    drug.gsub('_', ' ')
  end

  def saf_hates_ops(m)
    return m.user.nick == 'safiire' || m.user.nick == 'safk'
  end

  def greet (m, &block)
    same_user = @last_login == m.user.realname
    @last_login = m.user.realname

    if saf_hates_ops(m)
      m.reply "I hear you hate OPIATES, #{m.user.nick}! ;)"
      return
    end

    if same_user
      m.reply "Have some #{@drug_classes.sample}, #{m.user.nick}!"
    else
      m.reply "Have some OPIATES, #{m.user.nick}!"
    end

    block.call
  end

end

include Cinch::FiendyGreet

bot = Cinch::Bot.new do
  extend Cinch::Respond

  @last_login = @bot

  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = [CHANNEL]
    c.nick = NICK
    c.plugins.plugins = [Fortune, Say, Reload, Ekto,
                         Cinch::Plugins::UrbanDictionary,
                         Cinch::Plugins::Haiku]
  end

  on :join do |m|
    Cinch::FiendyGreet.greet(m) { m.channel.op(m.user) unless m.channel.opped?(m.user) || m.user == @bot }
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

  respond_to('test') do |m|
    m.reply "#{m.inspect}"
  end

end

bot.start
