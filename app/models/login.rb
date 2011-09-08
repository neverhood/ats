class Login < ActiveRecord::Base
  validates_uniqueness_of :title
  validates_presence_of :login
  validates_presence_of :password
  validates_presence_of :url
  has_many :sites, :dependent => :nullify
end
