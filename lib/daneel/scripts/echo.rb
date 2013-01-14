require 'daneel/script'

class EchoScript < Daneel::Script
  def receive(message)
    say message
  end
end
