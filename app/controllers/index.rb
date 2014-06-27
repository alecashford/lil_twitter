get '/' do

  if session[:user_id]
    followed = User.find(session[:user_id]).followed_users
    @tweets = []
    @users = []
    followed.each do |user|
      @tweets << user.tweets

    end
    @tweets.flatten!
    @tweets.sort_by! {|tweet| tweet.created_at}.reverse!
  end
  if session[:user_id]
    @user = User.find_by_id(session[:user_id])
  end
  erb :index
end

#----------- SESSIONS -----------

get '/profile/:id' do
  @user_tweets = Tweet.where(:user_id => params[:id])
  @user = User.where(:id => params[:id]).first
  @user_id = params[:id]
  erb :profile
end

get '/following/:id' do
  @user = User.where(:id => params[:id]).first
  @following = @user.followed_users
  erb :following
end

get '/sessions/new' do
  @title = "Sign In"
  erb :sign_in
end

post '/sessions' do
  user = User.find_by_username(params[:username])
  if user
    if user.password == params[:password]
      session[:user_id] = user.id
      session[:username] = user.username
      session[:first_name] = user.first_name
      session[:last_name] = user.last_name
      redirect '/'
    else
      @error = "Wrong password. Try again."
      erb :sign_in
    end
  else
    @error = "Username not found. Try again."
    erb :sign_in
  end
end

get '/sessions/logout' do
  session.clear
  redirect '/'
end



get '/logout' do
  session.clear
  redirect '/'
end

get '/register' do
  erb :register
end

post '/register' do
  session.clear
  if params[:password]==params[:password_confirm]
    User.create(username: params[:username], password: params[:password], first_name: params[:first_name], last_name: params[:last_name])
    user = User.find_by_username(params[:username])
    session[:user_id] = user.id
    session[:username] = user.username
    session[:first_name] = user.first_name
    session[:last_name] = user.last_name
    redirect '/'
  else
    session[:invalid_password] = true
    redirect '/register'
  end
end

post '/retweets' do
  p Tweet.create(content: params[:tweet_content], user_id: session[:user_id], author_id: params[:user_id])
  redirect '/'
end

get '/display_all' do
  @all_users = User.all
  @following = User.find(session[:user_id]).followed_users
  erb :display_all_users
end

get '/follow/:id' do
  User.find_by_id(session[:user_id]).followed_users << User.find_by_id(params[:id]) unless User.find_by_id(session[:user_id]).followed_users.include?(User.find_by_id(params[:id]))
  redirect '/display_all'
end

get '/unfollow/:id' do
  User.find_by_id(session[:user_id]).followed_users.delete(User.find_by_id(params[:id])) if User.find_by_id(session[:user_id]).followed_users.include?(User.find_by_id(params[:id]))
  redirect '/display_all'
end

post '/tweets' do
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

