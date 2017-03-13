class VideoUpdater
  include Sidekiq::Worker

  def perform
  	loop {
  		Video.parse
  		puts "Okay.."
  		sleep 3.hours
  	}
  end
end