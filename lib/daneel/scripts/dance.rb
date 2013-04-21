# Dance!
#
# \o/ - Receive a happy dance gif.
class Dance < Daneel::Script::Image
  image_on(%r|\o/|i)
  images %w(http://factoryjoe.s3.amazonaws.com/emoticons/emoticon-0169-dance.gif)
end