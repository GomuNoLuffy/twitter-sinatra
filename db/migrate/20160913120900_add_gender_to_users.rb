class AddGenderToUsers < ActiveRecord::Migration
	def change
		add_column :users, :gender, :integer, default: 0, index: true
	end
end