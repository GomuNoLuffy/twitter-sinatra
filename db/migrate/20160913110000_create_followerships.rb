class CreateFollowerships < ActiveRecord::Migration
	def change
		create_table :followerships do |t|
			t.references :follower
			t.references :followed
	    end
	end
end