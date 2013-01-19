require 'daneel/script'

module Daneel
  module Scripts
    class Meme < Daneel::Script

      def receive(room, message)
        case message.text
        when /^[\:\*\(e]?facepalm[\:\*\)]?|EFACEPALM|:fp|m\($/i
          room.say_random [
            # picard facepalm
            "https://img.skitch.com/20110224-875h7w1654tgdhgrxm9bikhkwq.jpg",
            # polar bear facepalm
            "https://img.skitch.com/20110224-bsd2ds251eit8d3t1y2mkjtfx8.jpg"
          ]
        when /^[\:\*\(e]?double ?facepalm[\:\*\)]?|:fpfp|m\( m\($/i
          # picard + riker facepalm
          room.say "https://img.skitch.com/20110224-ncacgpudhfr2s4te6nswenxaqt.jpg"
        when /^i see your problem/i
          # pony mechanic
          room.say "https://img.skitch.com/20110224-8fmfwdmg6kkrcpijhamhqu7tm6.jpg"
        when /^wfm|womm|works on my machine$/i
          # works on my machine
          room.say "https://img.skitch.com/20110224-jrcf6e4gc936a2mxc3mueah2in.png"
        when /^stacktrace or gtfo|stacktrace or it didn't happen|stacktrace\!$/i
          # stacktrace or gtfo
          room.say "https://img.skitch.com/20110224-pqtmiici9wp9nygqi4nw8gs6hg.png"
        when /^this is sparta\!*$/i
          # this is sparta
          room.say "https://img.skitch.com/20110225-k9xpadr2hk37pe5ed4crcqria1.png"
        when /^i have no idea what i'm doing$/i
          # I have no idea what I'm doing
          room.say "https://img.skitch.com/20110304-1tcmatkhapiq6t51wqqq9igat5.jpg"
        when /^party[?!.]*$/i
          # party party party party party cat
          room.say "https://img.skitch.com/20110309-qtd33sy8k5yrdaeqa9e119bwd1.jpg"
        when /^bomb|system error$/i
          # sorry, a system error has occurred
          room.say "https://img.skitch.com/20110312-8g31a37spacdjgatr82g3g98j1.jpg"
        when /^stop hitting yourself$/i
          # and the angel said to him, Stop hitting yourself!
          room.say "https://img.skitch.com/20110316-q7h49p69pjhhyy8756rha2a1jf.jpg"
        end
      end

    end
  end
end
