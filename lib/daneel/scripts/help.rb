require 'daneel/script'

module Daneel
  module Scripts
    class Help < Daneel::Script

      def receive(room, message)
        case message.command
        when /help$/
          col = helps.keys.map(&:length).max + 2
          room.say helps.map{|k,v| "%-#{col}s %s" % [k,v] }.sort.join("\n")
        when /help (.+)/
          room.say helps[$1]
        end
      end

      def help
        {"help" => "show this help summary"}
      end

    private

      def helps
        @helps ||= begin
          helps = {}
          robot.scripts.each do |script|
            helps.merge!(script.help)
          end
          logger.debug "Found helps: #{helps.inspect}"
          helps
        end
      end

    end
  end
end
