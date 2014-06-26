get '/' do
  # Look in app/views/index.erb
  if session[:user_id]
    @user = User.find_by_id(session[:user_id])
  end
  erb :index
end



#----------- SESSIONS -----------

get '/profile/:id' do
  @user_tweets = Tweet.where(:user_id => params[:id])
  @user = User.where(:id => params[:id]).first
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

delete '/sessions/:id' do
  session.clear
  redirect '/'
  # sign-out -- invoked
end


get '/register' do
  erb :register
end

post '/register' do
  session.clear
  if params[:password]==params[:password_confirm]
    User.create(username: params[:username], password: params[:password], first_name: params[:first_name], last_name: params[:last_name])
    user = User.find_by_username(params[:username])
    session[:login] = true
    session[:user_id] = user.id
    session[:username] = user.username
    redirect '/'
  else
    session[:invalid_password] = true
    redirect '/register'
  end
end


get '/display_all' do
  dupes_equals_true = User.find_by_id(session[:user_id].to_i).followed_users.include? User.find_by_id(params[:user_id].to_i)
  if params[:user_id]
    unless session[:user_id].to_i == params[:user_id].to_i
      unless dupes_equals_true
        User.find_by_id(session[:user_id].to_i).followed_users << User.find_by_id(params[:user_id].to_i)
      end
    end
  end
  @all_users = User.all
  erb :display_all_users
end

post '/display_all' do
end

post '/tweets' do
  Tweet.create(content: params[:tweet_content], user_id: session[:user_id])
  redirect '/'

end

get '/followers/:id' do
  @this_user = User.find_by_id(params[:id])
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