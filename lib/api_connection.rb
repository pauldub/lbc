module APIConnection
  def connection(options={})
    options = {
      :url => 'http://www.leboncoin.fr',
    }.merge options

    @connection ||= Faraday.new :url => options[:url] do |faraday|
      faraday.request :url_encoded
      faraday.adapter :typhoeus
      faraday.use FaradayMiddleware::FollowRedirects, limit: 5
    end
    @connection
  end
end
