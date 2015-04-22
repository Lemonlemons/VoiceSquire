class Duke < ActiveRecord::Base
  validates :email, :presence => {message:"is missing an input"}
  validates :firstname, :presence => {message:"is missing an input"}
  validates :lastname, :presence => {message:"is missing an input"}
  validates :phonenumber, :uniqueness => {message:"is already taken"}, :presence => {message:"is missing an input"}
  validates :physicaladdress, :presence => {message:"is missing an input"}
  validates :physicalcity, :presence => {message:"is missing an input"}
  validates :physicalstate, :presence => {message:"is missing an input"}
  validates :physicalzipcode, :presence => {message:"is missing an input"}
  validates :birthday, :presence => {message:"is missing an input"}
  validates :phonenumber, :length => {maximum:12, minimum:10, message:"must be 10 digits"}
end
