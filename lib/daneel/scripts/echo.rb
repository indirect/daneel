require 'daneel/script'

module Daneel
  module Scripts
    class Echo < Daneel::Script

      def run
        respond(/^(?:echo|say)\s(.+)/) do |words|
          say words
        end
      end

      def help
        {"echo TEXT" => "are you copying me? stop copying me!"}
      end

    end
  end
end
