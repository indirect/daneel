require 'daneel/script'

module Daneel
  module Scripts
    class Chatty < Daneel::Script

      def receive(message)
        case message.text
        when /^(night|good ?night)(,?\s(all|every(body|one)))$/i
          bot.say "goodnight, #{message.user.name}"
          message.finish
        end
        when /^(morning|good ?morning)(,?\s(all|every(body|one)))$/i
          bot.say "good morning, #{message.user.name}"
          message.finish
        end
      end

    end
  end
end
