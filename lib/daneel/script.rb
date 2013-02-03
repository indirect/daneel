require 'daneel/plugin'

module Daneel
  class Script < Plugin

    def accepts?(room, message, user)
      self.class.accepts?(room, message, user)
    end

    def receive(room, message, user)
      # do stuff here!
    end

    def help
      # return a hash of commands and descriptions for help listings
      {}
    end

    # Track scripts that have loaded so we can use them
    class << self

      def list
        @list ||= []
      end

      def inherited(subclass)
        list << subclass
      end

      def files
        Dir[File.expand_path("../scripts/*.rb", __FILE__)]
      end

      def accept(*types)
        if types.empty?
          @accept || ["text"]
        else
          @accept = types.map{|t| t.to_s }
        end
      end

      def sent_to(whom = nil)
        if whom.nil?
          @sent_to || :me
        else
          @sent_to = whom
        end
      end

      def match(*patterns)
        if patterns.empty?
          @match || [/.*/]
        else
          @match = patterns
        end
      end

      def accepts?(room, message, user)
        accept_type = accept.include? message.type

        case sent_to
        when :me
          accept_sent_to = !message.command.nil?
        when :anyone
          accept_sent_to = true
        end

        accept_match = match.find{|p| p.match(message.text) }

        accept_type && accept_sent_to && accept_match
      end

    end

  end
end

# TODO swap in the implementation below
#
# class Daneel::Script
#   accept :text
#   sent_to :me
#   match /.*/
#
#   attr_reader :message, :robot, :room, :user
#
#   def initialize(robot, room, user, message)
#     @robot, @room, @user, @message = robot, room, user, message
#   end
#
#   def me
#     @robot.me
#   end
#
#   def data
#     @robot.data
#   end
#
#   def reply(*strings)
#     @robot.reply room, user, *strings.map{|s| user.to_s + [?:,?,].sample + ' ' + s }
#   end
#
#   def say(*strings)
#     @robot.say room, *strings
#   end
#
#   def handle(args)
#     # do stuff here! go crazy!
#   end
#
# end

# TODO implement plugins for the new API
#
# class ImageSearch < Daneel::Script
#   # accept :text # default from the superclass
#   # sent_to :me # default from the superclass
#   match "image me", "img me",
#     /find(?: me)? a(?: picture of)? (.+)/,
#     /find(?: me)? an(?: image of)? (.+)/
#
#   def run(search)
#     say image_url_for(search)
#   end
#
# end
#
# class Logger < Daneel::Script
#   accept :all # not just text
#   sent_to :anyone # not just the bot
#
#   def run
#     data["messages"] << msg
#   end
#
# end
#
# class YouTube < Daneel::Script
#   match "youtube me", "yt me"
#
#   def run(search)
#     tubes = robot.get_json("http://youtube.com/search",
#       q: search, alt: 'json', 'max-results': 15, orderBy: 'revelance')
#     link = tubes["feed"]["entry"].sample["link"].find do |l|
#       l["rel"] == "alternate" && l["type"] == "text/html"
#     end
#     say link
#   end
#
# end
#
# class Maps < Daneel::Script
#   match "map me",
#     /(?:(satellite|terrain|hybrid)[- ])?map me (.+)/,
#     /show( me)? a map of (.+)/
#
#   def run(args)
#     args.unshift nil if args.length == 1
#     args[0] ||= "roadmap"
#     say map_image(args[0], args[1])
#     say map_link(args[0], args[1])
#   end
# end
#
