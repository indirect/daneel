require 'sinatra/base'
module Daneel
  class Web < Sinatra::Base
    set :logging, true

    get '/' do
      content_type "text/plain"
      "I hope to one day have a positronic brain, like my namesake R. Daneel Olivaw."
    end

  end
end
