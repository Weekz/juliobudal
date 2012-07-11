class CreateAdminContacts < ActiveRecord::Migration
  def change
    create_table :admin_contacts do |t|

      t.timestamps
    end
  end
end
