class FetchLinkJob < Struct.new(:id)
  def perform
    link = Link.find(id)

    if link
      link.update_attributes last_fetch: Time.now.to_datetime

      details = link.create_details
      details.fetch

      #images = link.create_images
      #images.fetch
    end
  end
end
