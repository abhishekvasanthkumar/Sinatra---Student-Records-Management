require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'slim'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student-record.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :degree, String
  property :degree_date, String
  property :concentration, String
end

class Users
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :password, String
  property :given_name, String
  property :is_logined, String
  property :last_login, Date
end

DataMapper.finalize

Users.auto_upgrade!
Student.auto_upgrade!


get '/students' do	#route for students
  if admin?
  @records = Student.all
  slim :students
  else
  redirect to ('/')
end
end

get '/students/new' do	#route for new student record
if admin?	#check if admin or not and the perform the actions accordingly
  @record = Student.new
  slim :new_student
  else
  redirect to ('/')
end
end

get '/students/:id' do #route for showing student record based on id
if admin?	#check if admin or not and the perform the actions accordingly
  @record = Student.get(params[:id])
  slim :show_student
  else
  redirect to ('/')
end
end

get '/students/:id/edit' do #edit route for student record
 if admin?	#check if admin or not and the perform the actions accordingly
	@record = Student.get(params[:id])
	slim :edit_student
 else
	redirect to ('/')
end
end

post '/students' do	#route show student records
 if admin?	#check if admin or not and the perform the actions accordingly
  record = Student.create(params[:record])
  redirect to("/students/#{record.id}")
  else
	redirect to ('/')
end
end

put '/students/:id' do #update existing record
if admin?	#check if admin or not and the perform the actions accordingly
  record = Student.get(params[:id])
  record.update(params[:record])
  redirect to("/students/#{record.id}")
  else
	redirect to ('/')
end
end

delete '/students/:id' do	#deleting existing student record
 if admin?	#check if admin or not and the perform the actions accordingly
 Student.get(params[:id]).destroy
 redirect to('/students')
 else
	redirect to ('/')
end
end

post '/login' do	#login route to check the username and password set in the sessions
if (params[:username] == settings.username && params[:password] == settings.password)
session[:admin] = true
redirect to ('/students')
else
slim :try_again
end
end

#get '/login_form' do
#slim :login
#end


#get '/logout' do
#session.clear
#redirect to ('/login')
#end