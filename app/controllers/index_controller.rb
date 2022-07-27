class IndexController < ApplicationController
  def index
    @messages = Message.all
    raise "debugging crash here"
  end
end
