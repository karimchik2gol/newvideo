class Video < ActiveRecord::Base
	extend ParseTrends
	belongs_to :channel
end
