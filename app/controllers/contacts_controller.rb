class ContactsController < ApplicationController
  def create
    @contact = Contact.new(params[:contact])

    if @contact.save
      redirect_to root_url, notice: "Thanks for your message."
    else
      redirect_to :back, alert: "Please fill all fields."
    end
  end
end
