class IndexController < ApplicationController
  def index
    @messages = Message.all
    raise "huh"
  end
end
