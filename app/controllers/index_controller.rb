class IndexController < ApplicationController
  def index
    @messages = Message.all
  end
end
