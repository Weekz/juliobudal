class Admin::ContactsController < Admin::BaseController

  def index
    @contacts = ::Contact.all
  end

  def destroy
    @contact = ::Contact.find(params[:id])
    @contact.destroy

    redirect_to admin_contacts_url
  end
end
