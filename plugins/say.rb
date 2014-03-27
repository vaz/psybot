class Say
  include Cinch::Plugin

  match(/say (.+)/)
  def execute(m, message)
    Channel(CHANNEL).send(message)
  end

  match(/do (.+)/, method: :execute_action)
  def execute_action(m, action)
    Channel(CHANNEL).action(action)
  end
end

