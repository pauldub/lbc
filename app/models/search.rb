class SearchPage
  def initialize(response, options = {})
    @response = response
    @body = response.body
    @status = response.status
  end

=begin
  def save_links
    links do |attributes|
      link = Link.new(attributes)
      link.upsert

      yield link if block_given?
    end
  end
=end

  def links
    return unless success? and body

    doc = Nokogiri::HTML(@body)
    
    links = []

    doc.css('div.list-lbc a').each do |a|
      link = {
        :url => a['href'],
        :title => a.css('div.title').first.content.strip
      }

      link[:ad_id] = link[:url][/^http:\/\/www.leboncoin.fr\/locations\/(\d+).*/,1]
      links << link
      yield link if block_given?
    end

    links
  end

  def status
    @status
  end

  def body
    @body
  end

  def success?
    @status == 200
  end
end

class Search
  include Mongoid::Document
  include APIConnection

  extend Enumerize

  field :name, type: String

  field :rent_min, type: Integer
  field :rent_max, type: Integer

  field :area_min, type: Integer
  field :area_max, type: Integer

  field :rooms_min, type: Integer
  field :rooms_max, type: Integer

  field :misc
  enumerize :misc, in: [:house, :flat], multiple: true

  def bip_misc
    misc.to_a * ', '
  end

  field :furniture, type: Boolean

  field :location, type: String

  field :schedule
  enumerize :schedule, in: ['30 minutes'], default: '30 minutes'

  field :last_run, type: DateTime

  belongs_to :user
  has_and_belongs_to_many :users

  def shared_with?(user)
    user = User.find(id) unless user.is_a? User
    user == self.user || !users.find(user).nil?
  rescue Mongoid::Errors::DocumentNotFound
    false
  end

  has_many :links

  def scheduled_at
    Searches30MinutesJob.job.run_at if scheduled?
  end

  def scheduled?
    Searches30MinutesJob.scheduled?
  end

  %w(price surface).each do |criteria|
    define_method "average_#{criteria}" do
      links.avg("details.#{criteria}".to_sym)
    end
    
    define_method "max_#{criteria}" do
      links.max("details.#{criteria}".to_sym)
    end

    define_method "min_#{criteria}" do
      links.min("details.#{criteria}".to_sym)
    end
  end

  CATEGORY = {
    :rents => '12'
  }

  MISC = {
    :house => '1',
    :flat => '2',
    :plot => '3',
    :parking => '4',
    :other => '5',
  }

  ATTR_TABLE = {
    :category => 'c',
    :rent_min => 'mrs',
    :rent_max => 'mre',
    :area_min => 'sqs',
    :area_max => 'sqe',
    :rooms_min => 'ros',
    :rooms_max => 'roe',
    :misc => 'ret',
    :furnitures => 'furn',
    :location => 'location'
  }

  def to_search
    ret = {
      'f' => 'a',
      'c' => '10'
    }

    ATTR_TABLE.each do |k, attribute|
      v = attributes[k.to_s]

      if v
        attribute = ATTR_TABLE[k.to_sym]

        case k
        when :category
          ret[attribute] = CATTEGORY[v]
        when :misc
          if v.is_a? Array
            #ret[attribute] = []
            v.each do |value|
              #ret[attribute].push MISC[value]
            end
          end
        when :furnitures
          ret[attribute] = v === true ? 1 : 2
        else
          ret[attribute] = v
        end
      end
    end
    ret
  end

  def search_page
    res = self.connection.get do |req|
      req.url '/locations/offres/nord_pas_de_calais/'
      req.params = to_search
    end

    SearchPage.new res
  end
end

