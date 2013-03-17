# Gin is delicious. Let Hubot serve you some.
#
# gin me - Receive a picture of some delicious gin.

# List of pictures of various gin drinks (mostly Hendrick"s) pulled at random
# from a Google image search.
class Gin < Daneel::Script

  def run
    listen(/gin me$/i) do
      say a_gin
    end
  end

  def a_gin
    [
      "http://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Hendrick%27s_Gin_1l_with_cup.jpg/600px-Hendrick%27s_Gin_1l_with_cup.jpg",
      "http://farm2.staticflickr.com/1277/4608612744_99df3f2db8_z.jpg",
      "http://img2.timeinc.net/health/images/slides/minted-gin-froths-400x400.jpg",
      "http://sweetpaprika.files.wordpress.com/2011/08/drinks-lemon1.jpg",
      "http://s3.amazonaws.com/cmi-niche/assets/pictures/480/content_drink3.jpg",
      "http://www.ridenourphoto.com/wp-content/uploads/2011/11/Ridenour_Product_FA11.jpg",
      "http://i-cdn.apartmenttherapy.com/uimages/kitchen/081810_lizv_gin.jpg",
      "http://c745.r45.cf2.rackcdn.com/img/2009/hendricks_gin.jpg",
      "http://ipreferboozehound.files.wordpress.com/2010/07/img_03131.jpg"
    ].sample
  end

end
