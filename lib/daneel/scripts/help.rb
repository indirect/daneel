require 'daneel/script'

class HelpScript < Daneel::Script
  def receive(message)
    case message.command
    when /help$/
      say helps.map{|s| s.map{|h| h.join(" - ") }.join("\n") }
    when /help (.+)/
      say helps.to_a.find{|h| h[$1] }[$1]
    end
  end

  def help
    {"help" => "show this help summary"}
  end

private

  def helps
    @helps ||= robot.scripts.map(&:help).compact
    logger.debug "Found helps: #{@helps.inspect}"
    @helps
  end

end