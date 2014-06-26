get '/' do
  # Look in app/views/index.erb
  erb :index
end



#----------- SESSIONS -----------

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

