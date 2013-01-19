require 'daneel/script'

module Daneel
  module Scripts
    class Echo < Daneel::Script

      def receive(message)
        case message.command
        when /^echo (.+)/
          say $1
        end
      end

    end
  end
end
