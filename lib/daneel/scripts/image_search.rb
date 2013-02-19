require 'cgi'
require 'net/http/persistent'

module Daneel
  # You need an Azure Marketplace Bing Search API key. You can sign up for one here:
  # https://datamarket.azure.com/dataset/bing/search
  # A free subscription allows 5,000 searches per month.
  module Scripts
    class ImageSearch < Daneel::Script
      requires_env "AZURE_API_KEY"

      def run
        respond(/^(?:find) (?:me )?(?:a |another )?(?:picture of )?(.*)$/,
            /image me (.*?)/) do |query|
          say find_image_url_for(query)
        end
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
        request.basic_auth 'x', ENV['AZURE_API_KEY']
        response = robot.request uri, request
        results = JSON.parse(response.body)["d"]["results"].first["Image"]
        logger.debug "got back #{results.size} images"
        # Random image from the first 50 results
        results.sample["MediaUrl"]
      rescue => e
        logger.error "#{e.class}: #{e.message}"
        say "Sorry, something went wrong when I looked for that :("
      end

    end
  end
end
