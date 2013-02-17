class SearchJob < Struct.new(:id)
  def perform
    search = Search.find(id)

    if search
      search.update_attributes last_run: Time.now.to_datetime

      page = search.search_page
      page.links do |attributes|
        link = search.links.find_or_create_by(attributes)
        Delayed::Job.enqueue FetchLinkJob.new link.id
      end
    end
  end
end
