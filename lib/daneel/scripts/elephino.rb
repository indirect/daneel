# Elephino!
#
# Commands
#   hell if I know - Receive a picture of an Elephino.
#
# Authors:
#   indirect

class Elephino < Daneel::Script::Image
  image_on(/hell if I know/i)

  images %w(
    http://fc09.deviantart.net/fs70/i/2012/220/b/1/the_great_elephino_by_ritter99-d5ad9zc.jpg
    http://fc08.deviantart.net/fs71/f/2010/190/9/3/Elephino_by_weedface420.jpg
    https://lh5.googleusercontent.com/-aUrn_J_zyBs/TW_KqXoIp-I/AAAAAAAAB8U/3uKF9W6zIwc/s1600/elephino_by_jgannon.jpg
  )
end
