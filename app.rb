# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def connection
  @conn = PG.connect(dbname: 'memotest')
end

get '/' do
  connection
  @memo_contents = @conn.exec('SELECT * FROM memo ORDER BY id')
  erb :index
end

post '/' do
  connection
  title = params[:title]
  comment = params[:comment]
  new_memo = @conn.exec("INSERT INTO memo (title, comment) VALUES ('#{title}', '#{comment}') RETURNING id").first
  id = new_memo['id']
  redirect to("/memo/#{id}")
end

get '/new' do
  erb :new
end

get '/memo/:id' do |id|
  connection
  @memo = @conn.exec("SELECT * FROM memo WHERE id = '#{id}'").first
  erb :show
end

get '/edit/:id' do |id|
  connection
  @memo = @conn.exec("SELECT * FROM memo WHERE id = '#{id}'").first
  erb :edit
end

patch '/edit/:id' do |id|
  title = params[:title]
  comment = params[:comment]
  connection
  @conn.exec("UPDATE memo SET title = '#{title}', comment = '#{comment}' WHERE id ='#{id}'")
  redirect to("/memo/#{id}")
end

delete '/edit/:id' do
  id = params[:id]
  connection
  @conn.exec("DELETE FROM memo WHERE id ='#{id}'")
  redirect to('/')
end

not_found do
  erb :not_found
end
