require 'cgi'
require 'net/http/persistent'

module Daneel
  # You need an Azure Marketplace Bing Search API key. You can sign up for one here:
  # https://datamarket.azure.com/dataset/bing/search
  # A free subscription allows 5,000 searches per month.
  module Scripts
    class ImageSearch < Daneel::Script
      requires_env "AZURE_API_KEY"

      def initialize(robot)
        super
        @token = ENV['AZURE_API_KEY']
        @http = Net::HTTP::Persistent.new('daneel')
      end

      def receive(room, message, user)
        case message.command
        when /image me (.*?)/, /^(?:find) (?:me )?(?:a |another )?(?:picture of )?(.*)$/
          room.say find_image_url_for($1)
          message.done!
        end
      rescue => e
        logger.error "#{e.class}: #{e.message}"
        room.say "Sorry, something went wrong when I looked for '#{query}'"
      end

      def help
        {"find a THING" => "scours the internets for a picture of THING to show you"}
      end

      def find_image_url_for(search)
        logger.debug "Searching for images of #{search}"
        query = CGI.escape("'#{search.gsub(/'/, "\\\\'")}'")
        uri = URI("https://api.datamarket.azure.com/Bing/Search/v1/Composite")
        uri.query = "Sources=%27image%27&Adult=%27Moderate%27&$format=JSON&Query=#{query}"
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth 'x', @token
        response = @http.request uri, request
        logger.debug "GET #{uri}"
        results = JSON.parse(response.body)["d"]["results"].first["Image"]
        logger.debug "got back #{results.size} images"
        # Random image from the first 50 results
        results.sample["MediaUrl"]
      end

    end
  end
end
