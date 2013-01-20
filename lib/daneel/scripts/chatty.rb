require 'daneel/script'

module Daneel
  module Scripts
    class Chatty < Daneel::Script

      def receive(room, message, user)
        # Said to the room in general
        case message.text
        when /^(night|good ?night)(,?\s(all|every(body|one)))$/i
          room.say "goodnight, #{user}"
        when /^(morning|good ?morning)(,?\s(all|every(body|one)))$/i
          room.say "good morning, #{user}"
        end

        # Said directly to the bot
        case message.command
        when nil
          # don't reply to things not addressed to the bot
        when /^\s*$/
          # question questioners, exclaim at exclaimers, dot dotters
          message.body.match(/(\?|\!|\.)$/)
          room.say(user + $1.to_s)
        when /^(hey|hi|hello|sup|howdy)/i
          room.say("#{$1} #{user}")
        when /how are (you|things)|how\'s it (going|hanging)/i
          room.say [
            "Oh, you know, the usual.",
            "can't complain",
            "alright, how about you?",
            "people say things, I say things back"
          ].sample
        when /(^later|(?:good\s*)?bye)/i
          room.say("#{$1} #{user}")
        when /you rock|awesome|cool|nice/i
          room.say [
            "Thanks, #{user}, you're pretty cool yourself.",
            "I try.",
            "Aw, shucks. Thanks, #{user}."
          ].sample
        when /(^|you|still)\s*there/i, /\byt\b/i
          room.say %w{Yup y}.sample
        when /wake up|you awake/i
          room.say("yo")
        when /thanks|thank you/i
          room.say ["No problem.", "np", "any time", "that's what I'm here for", "You're welcome."].sample
        when /^(good\s?night|(?:g')?night)$/i
          room.say [
            "see you later, #{user}",
            "later, #{user}",
            "night",
            "goodnight",
            "bye",
            "have a good night"
          ].sample
        when /^(see you(?: later)?)$/i
          room.say [
            "see you later, #{user}",
            "later, #{user}",
            "bye",
            "later",
            "see ya",
          ].sample
        when /^(?:get|grab|fetch|bring)(?: (.*?))?(?: (?:a|some))? coffee$/i
          person = $1
          if person =~ /(me|us)/
            person, do_they = "you", "do you"
          else
            do_they = "does #{person}"
          end

          room.say [
            "would #{person} like cream or sugar?",
            "how #{do_they} take it?",
            "coming right up",
            "It is by caffeine alone I set my mind in motion",
            "It is by the beans of Java that thoughts acquire speed",
            "The hands acquire shakes, the shakes become a warning",
            "It is by caffeine alone I set my mind in motion"
          ].sample
        else
          room.say [
            "I have no idea what you're talking about, #{user}.",
            "eh?",
            "oh, interesting",
            "say more, #{user}",
            "#{user}, you do realize that you're talking to a bot with a very limited vocabulary, don't you?",
            "Whatever, #{user}.",
            # TODO implement Bot#other_person
            # "#{bot.other_person(user)}, tell #{user} to leave me alone.",
            "Not now, #{user}.",
            "brb crying",
            "what do you think, #{user}?",
            "That's really something.",
            "but what can I do? I'm just a lowly bot",
            "I'll get some electrons on that right away",
            "How do you feel when someone says '#{message.command}' to you, #{user}?"
          ].sample
        end
      end

    end
  end
end
