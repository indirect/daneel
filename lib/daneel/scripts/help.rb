require 'daneel/script'

class HelpScript < Daneel::Script
  def receive(message)
    case message.command
    when /help$/
      say helps.map{|s| s.join(" - ") }.sort.join("\n")
    when /help (.+)/
      say helps[$1]
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