require 'daneel/script'

module Daneel
  module Scripts
    class Meme < Daneel::Script
      sent_to :anyone

      def run
        respond(/^[\:\*\(e]?facepalm[\:\*\)]?|EFACEPALM|:fp|m\($/i) do
          say [
            # picard facepalm
            "https://img.skitch.com/20110224-875h7w1654tgdhgrxm9bikhkwq.jpg",
            # polar bear facepalm
            "https://img.skitch.com/20110224-bsd2ds251eit8d3t1y2mkjtfx8.jpg"
          ].sample
        end

        respond(/^[\:\*\(e]?double ?facepalm[\:\*\)]?|:fpfp|m\( m\($/i) do
          # picard + riker facepalm
          say "https://img.skitch.com/20110224-ncacgpudhfr2s4te6nswenxaqt.jpg"
        end

        respond(/^i see your problem/i) do
          # pony mechanic
          say "https://img.skitch.com/20110224-8fmfwdmg6kkrcpijhamhqu7tm6.jpg"
        end

        respond(/^works on my machine|womm$/i) do
          # works on my machine
          say "https://img.skitch.com/20110224-jrcf6e4gc936a2mxc3mueah2in.png"
        end

        respond(/^stacktrace or gtfo|stacktrace or it didn't happen|stacktrace\!$/i) do
          # stacktrace or gtfo
          say "https://img.skitch.com/20110224-pqtmiici9wp9nygqi4nw8gs6hg.png"
        end

        respond(/^this is sparta\!*$/i) do
          # this is sparta
          say "https://img.skitch.com/20110225-k9xpadr2hk37pe5ed4crcqria1.png"
        end

        respond(/^i have no idea what i'm doing$/i) do
          # I have no idea what I'm doing
          say "https://img.skitch.com/20110304-1tcmatkhapiq6t51wqqq9igat5.jpg"
        end

        respond(/^party[?!.]*$/i) do
          # party party party party party cat
          cats = %w( http://cl.ly/image/2O2M0M2s303R/Party%20Cat%201.png
                     http://cl.ly/image/180B2c1N1K0q/Party%20Cat%202.png
                     http://cl.ly/image/3s0Y2W3O140X/Party%20Cat%203.png
                     http://cl.ly/image/3r1W0C0v0U2U/Party%20Cat%204.png
                     http://cl.ly/image/0w3i2f3V2R0y/Party%20Cat%205.png
                     http://cl.ly/image/0I0910011r0G/Party%20Cat%206.png
                     http://cl.ly/image/2S1L2e0o3n3M/Party%20Cat%207.png
                     http://cl.ly/image/2T2v1D2l3d3x/Party%20Cat%208.png
                     http://cl.ly/image/0i0p2C0I1T1I/Party%20Cat%209.png
                     http://cl.ly/image/1f1S2e0g3x2D/Party%20Cat%2010.png
                     http://cl.ly/image/0c373N0n0W1K/Party%20Cat%2011.png )
          room.say cats.sample

        respond(/^bomb|system error$/i) do
          # sorry, a system error has occurred
          say "https://img.skitch.com/20110312-8g31a37spacdjgatr82g3g98j1.jpg"
        end

        respond(/^stop hitting yourself$/i) do
          # and the angel said to him, Stop hitting yourself!
          say "https://img.skitch.com/20110316-q7h49p69pjhhyy8756rha2a1jf.jpg"
        end

        respond(/^victoly$/i) do
          # V I C T O L Y !
          say "http://www.blendernation.com/wp-content/uploads/2009/06/victoly.gif"
        end

        respond(/^[:*(]php[:*)]$/) do
          # PHP: training wheels without the bike
          say "http://tnx.nl/php.jpg"
        end
      end

    end
  end
end
