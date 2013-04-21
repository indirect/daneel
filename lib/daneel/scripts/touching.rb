# No touching!
#
# touch, touching - Be reminded of the touching policy.
class Touching < Daneel::Script::Image
  image_on(/\btouch(ing)?\b/i)
  images %w(http://cl.ly/image/3f2Z3H080W09/No%20touching.gif)
end