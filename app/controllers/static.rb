require 'byebug'

get '/' do
	if logged_in?
		@all_tweets = Tweet.includes(:user).paginate(:page => params[:page], :per_page => 10).order('created_at DESC')
		erb :"static/home"
	else
		erb :"static/login"
	end
end

get '/feed' do
	@all_tweets = Tweet.includes(:user).paginate(:page => params[:page], :per_page => 10).order('created_at DESC')
	erb :'static/feed', layout: false
end

post '/login' do
	user = User.authenticate(params[:user][:email], params[:user][:password])
	if user.nil?
		flash[:invalid_login] = "Invalid email or password"
	else
		session[:user_id] = user.id
	end

	redirect '/'
end

get '/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/signup' do
	erb :"static/signup"
end

post '/signup' do
	session[:error] = nil
	params[:user]['gender'] = params[:user]['gender'].to_i
	user = User.new(params[:user])

	if user.save
		session[:user_id] = user.id
		redirect '/'
	else
		flash[:error] = user.errors.full_messages.join("<br>")
		redirect '/signup'
	end
end

get '/forgetpwd' do
	erb :"static/forgetpwd"
end


get '/user/edit' do
	redirect '/' unless logged_in?
	erb :"static/edit"
end

post '/user/edit' do
	current_user.update(params[:user])

	if current_user.save
		redirect "/user/#{current_user.id}"
	else 
		redirect "/user/edit"
		flash[:edit_error] = current_user.errors.full_messages.join("<br>")
	end
end

post '/user/:followed_id/follow' do
	f = Followership.new(follower_id: current_user.id, followed_id: params[:followed_id])
	if !f.save
		flash[:notice] = f.errors.full_messages
	end
	redirect "/user/#{params[:followed_id]}"
end

post '/user/:followed_id/unfollow' do
	Followership.where(follower_id: current_user.id, followed_id: params[:followed_id]).destroy_all
	redirect "/user/#{params[:followed_id]}"
end


get '/user/:user_id' do
	redirect '/' unless logged_in?

	@user = User.find(params[:user_id])
	erb :"static/profile"
end

post '/user/tweet' do
	redirect '/' unless logged_in?
	tweet = current_user.tweets.new(content: params[:content])
	if tweet.save
		puts "[LOG] TWEET SAVED"
	else
		flash[:tweet_error] = tweet.errors.full_messages.join("<br>")
	end
	redirect '/'
end

get '/user/:user_id/tweets' do
	redirect '/' unless logged_in?
	@user = User.find(params[:user_id])
	@user_tweets = @user.tweets.all
	erb :"static/user-tweets", layout: !request.xhr?
end

get '/user/:user_id/following' do
	redirect '/' unless logged_in?
	user = User.find(params[:user_id])
	@followings = user.follower_in_followership.all
	erb :"static/following", layout: !request.xhr?
end

get '/user/:user_id/followers' do
	redirect '/' unless logged_in?
	user = User.find(params[:user_id])
	@followers = user.followed_in_followership.all
	erb :"static/followers", layout: !request.xhr?
end

get '/tweet/:tweet_id' do
	redirect '/' unless logged_in?
	@tweet = Tweet.find(params[:tweet_id])
	erb :"static/tweet"
end

post '/tweet/:tweet_id/edit' do
	tweet = Tweet.find(params[:tweet_id])
	tweet.update(content: params[:new_content])
	redirect "/tweet/#{tweet.id}"
end

post '/tweet/:tweet_id/delete' do
	tweet = Tweet.find(params[:tweet_id])
	user = tweet.user
	tweet.destroy
	redirect "/user/#{user.id}/tweets"
end






