get '/' do
  # Look in app/views/index.erb
  if session[:user_id]
    @user = User.find_by_id(session[:user_id])
  end
  erb :index
end



#----------- SESSIONS -----------

get '/profile' do
  @user_tweets = Tweet.where(:user_id => session[:user_id])
  @user = User.where(:id => session[:user_id]).first
  erb :profile
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
      @error = "Username/Password Combination is incorrect."
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

post '/tweets' do
  Tweet.create(content: params[:tweet_content], user_id: session[:user_id])
  redirect '/'
end

