class Fortune
  include Cinch::Plugin

  match "fortune"

  def execute(m)
    m.reply `fortune`
  end
end

