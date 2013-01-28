require 'cgi'
require 'json'
require 'net/http/persistent'

module Daneel
  module Scripts
    class VineSearch < Daneel::Script

      def initialize(robot)
        super
        @http = Net::HTTP::Persistent.new('daneel')
      end

      def receive(room, message, user)
        case message.command
        when /vine me (.+)$/, /^(?:find) (?:me )?(?:a |another )?(?:vine of )(.*)$/
          room.say find_vine_url_for($1)
          message.done!
        end
      end

      def help
        {"find a vine of THING" => "shows you a vine that was tweeted mentioning THING"}
      end

      def find_vine_url_for(search)
        logger.debug "Searching for a vine of #{search}"
        uri = URI("http://search.twitter.com/search.json")
        query = CGI.escape("#{search} source:vine_for_ios")
        uri.query = "rpp=5&include_entities=true&q=#{query}"
        request = Net::HTTP::Get.new(uri.request_uri)
        response = @http.request uri, request
        logger.debug "GET #{uri}"
        results = JSON.parse(response.body)["results"]
        logger.debug "got back #{results.size} vines"
        # Pull out the Vine display url of a random result
        results.sample["entities"]["urls"].first["expanded_url"]
      rescue => e
        logger.error "#{e.class}: #{e.message}"
        room.say "Sorry, something went wrong when I looked for '#{query}'"
      end

    end
  end
end
