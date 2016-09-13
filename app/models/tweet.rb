class Tweet < ActiveRecord::Base

	belongs_to :user

	validates :content, length: { in: 1..140 }
	validates :user_id, presence: true

	def time_ago
		(Time.now - (Time.now - created_at)).ago_in_words
	end
	
end
