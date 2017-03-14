# 1. Clear retry set

Sidekiq::RetrySet.new.clear

# 2. Clear scheduled jobs 

Sidekiq::ScheduledSet.new.clear

# 3. Clear 'Processed' and 'Failed' jobs statistics (OPTIONAL)

Sidekiq::Stats.new.reset

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { :size => 2 }
end