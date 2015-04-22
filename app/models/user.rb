class User < ActiveRecord::Base
  validates :email, :uniqueness => {message:"is already taken"}, :presence => {message:"is missing an input"}
  validates :firstname, :presence => {message:"is missing an input"}
  validates :lastname, :presence => {message:"is missing an input"}
  validates :phonenumber, :presence => {message:"is missing an input"}
  validates :address, :presence => {message:"is missing an input"}
  validates :city, :presence => {message:"is missing an input"}
  validates :state, :presence => {message:"is missing an input"}
  validates :zipcode, :presence => {message:"is missing an input"}
  validates :birthday, :presence => {message:"is missing an input"}
  validates :phonenumber, :length => {maximum:12, minimum:10, message:"must be 10 digits"}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
end
