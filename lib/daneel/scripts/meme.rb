require 'daneel/script'

module Daneel
  module Scripts
    class Meme < Daneel::Script

      def run
        listen(/^[\:\*\(e]?facepalm[\:\*\)]?|EFACEPALM|:fp|m\($/i) do
          say [
            # picard facepalm
            "https://img.skitch.com/20110224-875h7w1654tgdhgrxm9bikhkwq.jpg",
            # polar bear facepalm
            "https://img.skitch.com/20110224-bsd2ds251eit8d3t1y2mkjtfx8.jpg"
          ].sample
        end

        listen(/^[\:\*\(e]?double ?facepalm[\:\*\)]?|:fpfp|m\( m\($/i) do
          # picard + riker facepalm
          say "https://img.skitch.com/20110224-ncacgpudhfr2s4te6nswenxaqt.jpg"
        end

        listen(/^i see your problem/i) do
          # pony mechanic
          say "https://img.skitch.com/20110224-8fmfwdmg6kkrcpijhamhqu7tm6.jpg"
        end

        listen(/^works on my machine|womm$/i) do
          # works on my machine
          say "https://img.skitch.com/20110224-jrcf6e4gc936a2mxc3mueah2in.png"
        end

        listen(/^stacktrace or gtfo|stacktrace or it didn't happen|stacktrace\!$/i) do
          # stacktrace or gtfo
          say "https://img.skitch.com/20110224-pqtmiici9wp9nygqi4nw8gs6hg.png"
        end

        listen(/^this is sparta\!*$/i) do
          # this is sparta
          say "https://img.skitch.com/20110225-k9xpadr2hk37pe5ed4crcqria1.png"
        end

        listen(/^bomb|system error$/i) do
          # sorry, a system error has occurred
          say "https://img.skitch.com/20110312-8g31a37spacdjgatr82g3g98j1.jpg"
        end

        listen(/^stop hitting yourself$/i) do
          # and the angel said to him, Stop hitting yourself!
          say "https://img.skitch.com/20110316-q7h49p69pjhhyy8756rha2a1jf.jpg"
        end

        listen(/^victoly$/i) do
          # V I C T O L Y !
          say "http://www.blendernation.com/wp-content/uploads/2009/06/victoly.gif"
        end

        listen(/^[:*(]php[:*)]$/) do
          # PHP: training wheels without the bike
          say "http://tnx.nl/php.jpg"
        end

        listen(/fuck this/i) do
          # fuck that thing in particular
          say "http://files.arko.net/image/070t0O2x1d1D/fuck-this.gif"
        end

        listen(/no time to explain/i) do
          # get on the pony
          say "http://files.arko.net/image/0B0W1M2L2g1Q/no-time-to-explain.jpg"
        end
      end

    end
  end
end
