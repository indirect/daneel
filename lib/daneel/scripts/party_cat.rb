# Party cat
#
# Commands
#   party - party party party party party cat
#
# Authors:
#   indirect

class PartyCat < Daneel::Script::Image
  image_on(/^party[?!.]*$/i)

  images %w(
    http://cl.ly/image/2O2M0M2s303R/Party%20Cat%201.png
    http://cl.ly/image/180B2c1N1K0q/Party%20Cat%202.png
    http://cl.ly/image/3s0Y2W3O140X/Party%20Cat%203.png
    http://cl.ly/image/3r1W0C0v0U2U/Party%20Cat%204.png
    http://cl.ly/image/0w3i2f3V2R0y/Party%20Cat%205.png
    http://cl.ly/image/0I0910011r0G/Party%20Cat%206.png
    http://cl.ly/image/2S1L2e0o3n3M/Party%20Cat%207.png
    http://cl.ly/image/2T2v1D2l3d3x/Party%20Cat%208.png
    http://cl.ly/image/0i0p2C0I1T1I/Party%20Cat%209.png
    http://cl.ly/image/1f1S2e0g3x2D/Party%20Cat%2010.png
    http://cl.ly/image/0c373N0n0W1K/Party%20Cat%2011.png
  )
end
