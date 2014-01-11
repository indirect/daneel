# Internet high five!
#
# high five - Get a high five.
class HighFive < Daneel::Script::Image
  image_on(/high five/i)
  images %w(:hand: :pray::)
end