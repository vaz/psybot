require 'cinch'

#OPS = %w(vaz SyDy safiire Causai akhentek)

####
##  Bunch of responses for the bot when he hears a regex
Responses = {

  /psytrance/i => lambda do |m|
      m.reply("Psytrance is bad music, #{m.user.nick}") 
  end,

  /yay/i => lambda do |m|
      m.reply("Yaaaaaaaay!") 
      m.reply("/me explodes!")
  end
}


class Psytrance
  include Cinch::Plugin

end


bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = ["#PsytranceMessiah"]
    c.nick = ENV['NICK'] || "psybot"
  end

  on :join do |m|
    m.channel.op(m.user) unless m.channel.opped? m.user
  end

  on :message, /.+/ do |m|
    Responses.each do |regex, response_function|
      m.reply(response_function[m]) if regex.match(m.message) != nil
    end
  end
end

bot.start
