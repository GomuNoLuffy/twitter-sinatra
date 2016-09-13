
# user = {}
# dice = [0, 1, 2]
# user['password'] = 'asdf'
# user['password_confirmation'] = 'asdf'

# 20.times do

# 	user['first_name'] = Faker::Name.first_name 
# 	user['last_name'] = Faker::Name.last_name
# 	user['email'] = Faker::Internet.email
# 	user['gender'] = rand(1..2)

# 	case dice.sample
# 	when 1
# 		user['bio'] = Faker::Hacker.say_something_smart
# 	when 2
# 		user['bio'] = Faker::ChuckNorris.fact
# 	when 3
# 		user['bio'] = Faker::StarWars.quote
# 	end

# 	User.create(user)
# end



# # Get ids of all users
# uids = []
# User.all.each { |u| uids << u.id }

# # Seed 5 questions

# 60.times do
# 	Tweet.create(content: Faker::Hipster.sentence, user_id: uids.sample)
# end