class HomeController < ApplicationController
  def index
  end

  def message
    if (params[:name]) and (params[:email]) and (params[:message])
      Contact.create(name: params[:name], email: params[:email], message: params[:message])
      redirect_to root_path, notice: "Thanks for your message."
    else
      redirect_to root_path, alert: "Please fill all fields."
    end
  end
end
