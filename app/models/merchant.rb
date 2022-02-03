class Merchant < ActiveRecord::Base
  extend Devise::Models
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
end
