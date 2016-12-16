require 'sinatra'
require 'rubygems'
require 'slim'
require 'sass'
require './student_record'

get('/styles.css'){ scss :styles }

configure do
enable :sessions	#sessions to track
set :username, 'admin'	#username for login
set :password, 'admin123'	#password for login
end

helpers do	#helper method to check for admin all the time
  def admin?
    session[:admin]
  end
end

get '/' do	#Login Module. Eliminates '/login' url
  slim :login
end

#post '/login' do
#  session["user"] = params[:username]
#  redirect '/'
#end

get '/home' do	#Route for Homepage
  slim :home
end

get '/about' do	#Route for About page
  @title = "Students Record - About"
  slim :about
end

get '/contact' do	#Route for Contact page
  @title = "Students Record - Contact"
  slim :contact
end

#get '/students' do
#  @title = "Students Records"
#  slim :students
#end

get '/logout' do	#for logging out users
session.clear
session[:admin] = false
redirect to ('/')
end