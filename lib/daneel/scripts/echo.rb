require 'daneel/script'

class EchoScript < Daneel::Script

  def receive(message)
    case message.command
    when /^echo (.+)/
      say $1
    end
  end

end
