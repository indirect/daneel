require 'daneel/script'

module Daneel
  module Scripts
    class Chatty < Daneel::Script
      sent_to :anyone
      # TODO make this script the last-priority script
      # priority 20

      def run
        # Said to the room in general
        listen(/^(night|good ?night)(,?\s(all|every(body|one)))$/i) do
          say "goodnight, #{user}"
        end

        listen(/^(morning|good ?morning)(,?\s(all|every(body|one)))$/i) do
          say "good morning, #{user}"
        end

        listen(/coffee time/i) do
          say [
            "It is by caffeine alone I set my mind in motion",
            "It is by the beans of Java that thoughts acquire speed",
            "The hands acquire shakes, the shakes become a warning",
            "It is by caffeine alone I set my mind in motion"
          ].sample
        end

        # Said directly to the bot
        respond(/^\s*([?!.])$/) do |it|
          # question questioners, exclaim at exclaimers, dot dotters
          say "#{user}#{it}"
        end

        respond(/^(hey|hi|hello|howdy)/i) do |hi|
          say "#{hi} #{user}"
        end

        respond(/(^later|(?:good\s*)?bye)/i) do |bye|
          say("#{bye} #{user}")
        end

        respond(/how are (you|things)/i, /how\'s it (going|hanging)/i,
            /what'?s up\??|sup/i) do
          say [
            "Oh, you know, the usual.",
            "can't complain",
            "alright, how about you?",
            "people say things, I say things back"
          ].sample
        end

        respond(/you rock|awesome|cool|nice/i) do
          say [
            "Thanks, #{user}, you're pretty cool yourself.",
            "I try.",
            "Aw, shucks. Thanks, #{user}."
          ].sample
        end

        respond(/(^|you|still)\s*there/i, /\byt\b/i) do
          say %w{Yup y}.sample
        end

        respond(/wake up|you awake/i) do
          say("yo")
        end

        respond(/thanks|thank you/i) do
          say ["No problem.", "np", "any time",
            "that's what I'm here for", "You're welcome."].sample
        end

        respond(/^(good\s?night|(?:g')?night)$/i) do
          say [
            "see you later, #{user}",
            "later, #{user}",
            "night",
            "goodnight",
            "bye",
            "have a good night"
          ].sample
        end

        respond(/^(see you(?: later)?)$/i) do
          say [
            "see you later, #{user}",
            "later, #{user}",
            "bye",
            "later",
            "see ya",
          ].sample
        end

        respond(/^(?:(?:get|grab|fetch|bring) (.*?)|i need|time for)(?: (?:a|some))? coffee$/i) do |person|
          if person =~ /i|me|us/
            person, do_they = "you", "do you"
          else
            do_they = "does #{person}"
          end

          say [
            "would #{person} like cream or sugar?",
            "how #{do_they} take it?",
            "coming right up",
          ].sample
        end

        respond do
          say [
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
