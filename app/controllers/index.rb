get '/' do
  if session[:user_id]
    # find the current user
    @user = User.find_by_id(session[:user_id])
    # finds all users
    @users = User.all
    # find the tweets of users whom current user follows
    followed = @user.followed_users
    @tweets = []
    followed.each do |user|
      @tweets << user.tweets

    end
    @tweets.flatten!
    @tweets.sort_by! {|tweet| tweet.created_at}.reverse!
  end
  erb :index
end

#----------- SESSIONS -----------

get '/profile/:id' do
  # get current user
  @user = User.where(:id => params[:id]).first
  # get tweets of current user
  @user_tweets = Tweet.where(:user_id => params[:id])
  erb :profile
end

get '/following/:id' do
  @user = User.where(:id => params[:id]).first
  @following = @user.followed_users
  erb :following
end

get '/login' do
  erb :login
end

post '/login' do
  # query databse for user with supplied username
  credentials = User.find_by_username(params[:username])
  # if user exists, and supplied password is correct
  if credentials && credentials.password == params[:password]
      session[:user_id] = credentials.id
      redirect '/'
  # if user exists, but supplied password is incorrect
  elsif credentials
      @error = "Wrong password. Try again."
      erb :login
  # if user does not exist at all
  else
    @error = "Username not found. Try again."
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/register' do
  erb :register
end

post '/register' do
  user = User.create(username: params[:username], password: params[:password], first_name: params[:first_name], last_name: params[:last_name])
  session[:user_id] = user.id
  redirect '/'
end

post '/retweets' do
  p Tweet.create(content: params[:content], user_id: session[:user_id], author_id: params[:user_id])
  redirect '/'
end

get '/users' do
  @all_users = User.all
  @following = User.find(session[:user_id]).followed_users
  erb :users
end

get '/follow/:id' do
  User.find_by_id(session[:user_id]).followed_users << User.find_by_id(params[:id]) unless User.find_by_id(session[:user_id]).followed_users.include?(User.find_by_id(params[:id]))
  redirect '/users'
end

get '/unfollow/:id' do
  User.find_by_id(session[:user_id]).followed_users.delete(User.find_by_id(params[:id])) if User.find_by_id(session[:user_id]).followed_users.include?(User.find_by_id(params[:id]))
  redirect '/users'
end

post '/new_tweet' do
  Tweet.create(content: params[:tweet_content], user_id: session[:user_id], author_id: session[:user_id] )
  redirect '/'
end

get '/followers/:id' do
  @user = User.find_by_id(params[:id])
  my_id = params[:id].to_i
  users = User.all
  @followers = []
  users.each do |user|
    following = user.followed_users
    following.each do |possibly_me|
      if possibly_me.id == my_id
        @followers << user
        break
      end
    end
  end
  erb :followers
end

not_found do
  status 404
  erb :not_found
end

post '/retweet' do
  Tweet.create(content: params[:content], user_id: session[:user_id], author_id: params[:author_id])
  redirect '/'
end