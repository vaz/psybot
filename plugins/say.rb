class Say
  include Cinch::Plugin

  match(/say (.+)/)

  def execute(m, message)
    Channel(CHANNEL).send(message)
  end
end

