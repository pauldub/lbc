class User
  include Mongoid::Document

  authenticates_with_sorcery!

  field :username, type: String
  field :email, type: String
  field :password, type: String
  field :remember_me, type: Boolean

  has_many :searches
  has_and_belongs_to_many :users

  recommends :links
end
