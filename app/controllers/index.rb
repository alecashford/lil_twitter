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
  user = User.find_by_email(params[:email])
  if user
    if user.password_hash == params[:password]
      session[:user_id] = user.id
      redirect '/'
    else
      @error = "Email/Password Combination is incorrect."
      erb :sign_in
    end
  else
    @error = "Email not found. Try again."
    erb :sign_in
  end
end

delete '/sessions/:id' do
  session.clear
  redirect '/'
  # sign-out -- invoked
end
