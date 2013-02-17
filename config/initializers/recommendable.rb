Recommendable.configure do |config|
  config.orm = :mongoid
  config.auto_enqueue = true
  config.queue_name = :recommendable
  config.nearest_neighbors = nil
end
