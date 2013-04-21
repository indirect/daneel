# Sometimes things are cray.
#
# cray - Receive a picture of a Cray.
class Cray < Daneel::Script::Image
  image_on(/\bcray\b/i)
  images %w(
    http://cl.ly/image/142T1n0I0Z29/cray.png
    http://cl.ly/image/0b0L2F15183F/Letterpress%20Cray.png
    http://upload.wikimedia.org/wikipedia/en/0/07/Krays.jpg
  )
end