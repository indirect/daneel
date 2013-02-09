require 'cgi'
require 'json'
require 'net/http/persistent'

module Daneel
  module Scripts
    class VineSearch < Daneel::Script

      def receive(room, message, user)
        case message.command
        when /vine me (.+)$/, /^(?:find) (?:me )?(?:a |another )?(?:vine of )(.*)$/
          url = find_vine($1)
          if url
            room.say "#{url}, gif incoming..."
            gif = gif_for_vine(url)
            if gif
              room.say gif + "?.png" # so Campfire will inline it
            else
              room.say "gifvine didn't work, sorry"
            end
          else
            room.say "sorry, couldn't find any matching vine tweets"
          end
          message.done!
        end
      rescue => e
        message.done!
        logger.error "#{e.class}: #{e.message}"
        room.say "internet troubles, maybe try again later?"
      end

      def help
        {"find a vine of THING" => "shows you a vine that was tweeted mentioning THING"}
      end

    private

      def find_vine(search)
        logger.debug "Searching for a vine of #{search}"
        uri = URI("http://search.twitter.com/search.json")
        query = CGI.escape("#{search} source:vine_for_ios")
        uri.query = "rpp=5&include_entities=true&q=#{query}"
        request = Net::HTTP::Get.new(uri.request_uri)
        response = robot.request uri, request
        results = JSON.parse(response.body)["results"]
        logger.debug "got back #{results.size} vines"
        return nil if results.empty?
        # Pull out the Vine display url of a random result
        results.sample["entities"]["urls"].first["expanded_url"]
      end

      def gif_for_vine(vine)
        gifvine = vine.gsub(/vine.co/, "www.gifvine.co")

        # Try to get the gif URL from the HTML, first
        response = robot.request URI(gifvine)
        gif = response.body.scan(/<img src\='(.*?)'/) && $1
        return gif unless gif.nil? || gif.empty?

        # Otherwise, we have to replicate the new AJAX workflow
        robot.request URI(gifvine + "/ajax/fetch") # downloads the vine video
        response = robot.request URI(gifvine + "/ajax/convert") # does the gif-ification
        JSON.parse(response.body)["gif_url"]
      end

    end
  end
end
