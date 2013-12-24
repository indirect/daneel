require 'sparks'
require 'daneel/adapter'

module Daneel
  class Adapters
    class Campfire < Daneel::Adapter
      requires_env %w(CAMPFIRE_SUBDOMAIN CAMPFIRE_API_TOKEN CAMPFIRE_ROOM_IDS)

      def initialize(robot)
        super
        domain = ENV['CAMPFIRE_SUBDOMAIN']
        token  = ENV['CAMPFIRE_API_TOKEN']
        @fire  = Sparks.new(domain, token, :logger => logger)
        @me    = find_me

        ENV['CAMPFIRE_ROOM_IDS'].split(",").map(&:to_i).map do |id|
          # Get info about the room state
          room = Room.new(id, self, @fire.room(id))
          robot.data.rooms[id] = room
          # Save the user info for all the users in the room
          room.data[:users].each do |data|
            user = User.new(data[:id], data[:name], data)
            robot.data.users[user.id] = user
          end
        end
      end

      attr_reader :me

      def run
        @threads ||= []
        robot.data.rooms.each do |id, room|
          t = Thread.new { watch_room(room) }
          t.abort_on_exception = true
          @threads << t
        end
        @threads.each{|t| t.join }
      end

      def say(id, *texts)
        texts.each do |text|
          text =~ /\n/ ? @fire.paste(id, text) : @fire.speak(id, text)
        end
      end

      def announce(*texts)
        robot.data.rooms.each do |id, room|
          say id, *texts
        end
      end

      def leave
        # stop the listening threads
        @threads.each{|t| t.kill }
        # leave each room
        robot.data.rooms.each{|r| @fire.room(r.id).leave }
      end

    private

      def find_user(id)
        robot.data.users[id] ||= begin
          data = @fire.user(id)
          User.new(data[:id], data[:name], data)
        end
      end

      def find_me
        data = @fire.me
        data[:name].gsub!(/r\. /i, '') # a robot prefix isn't a name
        robot.data.users[data[:id]] = User.new(data[:id], data[:name], data)
      end

      def watch_room(room)
        @fire.watch(room.id) do |data|
          # We really just don't care about timestamps
          next if data[:type] == "TimestampMessage"

          room = robot.data.rooms[data[:room_id]]
          user = find_user(data[:user_id])
          time = Time.parse(data[:created_at]) rescue Time.now
          type = data[:type].gsub(/Message$/, '').downcase
          robot.receive room, user, Message.new(data[:body], time, type)
        end
      end

    end
  end
end
