class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :email
			t.string :encrypted_password
			t.string :first_name
			t.string :last_name
			t.text :bio

			t.timestamps
	    end
	end
end