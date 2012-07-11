class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name

  validates_presence_of :email, :message, :name
end
