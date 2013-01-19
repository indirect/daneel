require 'daneel/script'

module Daneel
  module Scripts
    class Echo < Daneel::Script

      def receive(room, message)
        case message.command
        when /^(?:echo|say)\s(.+)/
          room.say $1
        end
      end

      def help
        {"echo TEXT" => "are you copying me? stop copying me!"}
      end

    end
  end
end
