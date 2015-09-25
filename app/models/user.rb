require 'data_mapper'
require './app/data_mapper_setup'
require 'bcrypt'

class User

  attr_reader :password
  attr_accessor :password_confirmation

  include DataMapper::Resource

  validates_confirmation_of :password
  validates_uniqueness_of :email

  property :id, Serial
  property :email, String, required: true
  property :password_digest, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end