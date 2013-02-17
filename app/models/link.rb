module ActiveRecord
  class Base
  end
end

class Link
  include Mongoid::Document

  field :ad_id, type: String

  field :url, type: String
  field :title, type: String

  field :last_fetch, type: DateTime

  embeds_one :details

  belongs_to :search

  scope :latest, desc(:id).limit(5)
end
