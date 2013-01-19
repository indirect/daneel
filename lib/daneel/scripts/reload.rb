require 'daneel/script'
require 'pathname'

module Daneel
  module Scripts
    class Reload < Daneel::Script

      def receive(room, message)
        case message.command
        when /^update$/
          return unless in_git?
          system("cd #{root} && git pull origin master && bundle install")
          restart
        when /^reload$/
          say "Indeed. Reloading now."
          restart
        end
      end

      def help
        reload = {"reload" => "restarts and reloads #{robot.name}'s code"}
        update = {"update" => "updates #{robot.name}'s code from git and restarts"}
        in_git? ? reload.merge(update) : reload
      end

    private

      def restart
        bin = root.join("bin/daneel").realpath.to_s
        cmd = [Gem.ruby, "-S", bin, *ARGV]

        logger.debug "Reloading: #{cmd.join(' ')}"
        exec *cmd
      end

      def root
        @root ||= begin
          root = Pathname.new(__FILE__).join("../../../..").expand_path
          logger.debug "Found root directory #{root}"
          root
        end
      end

      def in_git?
        @in_git ||= root.join(".git").directory?
      end

    end
  end
end
