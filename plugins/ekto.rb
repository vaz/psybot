require 'cgi'


class Ekto
  include Cinch::Plugin

  match(/ekto (.+)/)

  def execute(m, query)
    query = CGI.escape(query)
    m.reply(`curl -I http://www.ektoplazm.com/index.php?s=#{query} | grep '^Location' | cut -f 2 -d' '`)
  end
end
