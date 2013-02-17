require File.expand_path 'lib/api_connection.rb', Rails.root

class Detail
  include Mongoid::Document
  include APIConnection

  #field :date, type: DateTime
  field :author, type: String
  field :description, type: String
  field :price, type: Integer
  field :price_string, type: String
  field :city, type: String
  field :zipcode, type: String
  field :type, type: String
  field :rooms, type: Integer
  field :furnitures, type: String
  field :surface, type: Integer
  field :surface_string, type: String
  field :ges, type: String
  field :energy_class, type: String

  embedded_in :link

  def fetch
    res = connection(url: link.url).get 
    return false unless res.status.to_i == 200 && res.body.length > 0
    doc = Nokogiri::HTML(res.body)

    hash = {}

    doc.css('div.upload_by').each do |upload_by|
      upload_by.css('a') do |author|
        hash[:author] = author.content.strip
      end
    end

    doc.css('span.price').each do |price|
      hash[:price_string] = price.content.strip
      hash[:price] = hash[:price_string][/\d+/].to_i
    end

    doc.css('div.lbcParams').each do |div|
      div.css('tr').each do |tr|
        if tr['class'].nil?
          tr.css('th').each do |th|
            case th.content.strip
            when /Ville/
              tr.css('td').each do |td|
                hash[:city] = td.content.strip
              end
            when /Code postal/
              tr.css('td').each do |td|
                hash[:zipcode] = td.content.strip
              end
            when /Type de bien/
              tr.css('td').each do |td|
                hash[:type] = td.content.strip
              end
            when /Pices/
              tr.css('td').each do |td|
                hash[:rooms] = td.content.strip.to_i
              end
            when /Meubl.+/
              tr.css('td').each do |td|
                hash[:furnitures] = td.content.strip
              end
            when /Surface/
              tr.css('td').each do |td|
                hash[:surface_string] = td.content.strip
                hash[:surface] = hash[:surface_string][/\d+/].to_i
              end
            when /GES/
              tr.css('td a').each do |a|
                hash[:ges] = a.content.strip[/^[A-G]/]
              end
            when /Classe .+nergie/
              tr.css('td a').each do |a|
                hash[:energy_class] = a.content.strip[/^[A-G]/]
              end
            end
          end
        end
      end
    end
    
    doc.css('div.AdviewContent div.content').each do |div|
      hash[:description] = div.content.strip.gsub(/<br>/, '\n')
    end

    self.update_attributes hash
  end
end
