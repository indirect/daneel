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

      def me
        @me ||= begin
          data = @fire.me
          data[:name].gsub!(/r\. /i, '') # a robot prefix isn't a name
          me = User.new(data[:id], data[:name], data)
          robot.data.users[me.id] = me
        end
      end

    private

      def find_user(id)
        robot.data.users[id] ||= begin
          data = @fire.user(id)
          User.new(data[:id], data[:name], data)
        end
      end

      def watch_room(room)
        @fire.watch(room.id) do |data|
          next if data[:type] == "TimestampMessage"

          # TODO pass through self-messages, once they are filtered by
          # the accept? method on scripts
          next if data[:user_id] == me.id

          text = data[:body]
          time = Time.parse(data[:created_at]) rescue Time.now
          type = data[:type].gsub(/Message$/, '').downcase
          mesg = Message.new(text, time, type)
          room = robot.data.rooms[data[:room_id]]
          user = find_user(data[:user_id])
          robot.receive room, mesg, user
        end
      end

    end
  end
end
