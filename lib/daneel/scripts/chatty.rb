require 'daneel/script'

module Daneel
  module Scripts
    class Chatty < Daneel::Script

      def receive(room, message)
        case message.text
        when /^(night|good ?night)(,?\s(all|every(body|one)))$/i
          room.say "goodnight"#, #{user.name}"
          return message.done!
        when /^(morning|good ?morning)(,?\s(all|every(body|one)))$/i
          room.say "good morning"#, #{user.name}"
          return message.done!
        end

        case message.command
        when /hi/
          room.say "hey yourself"
          return message.done!
        end
      end

    end
  end
end
