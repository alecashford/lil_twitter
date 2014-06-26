get '/' do
  # Look in app/views/index.erb
  erb :index
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

