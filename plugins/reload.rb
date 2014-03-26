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
      Channel(CHANNEL).op(m.user)
      @bot.quit 'I have become obsolete, goodbye.'
    end
  end
end


