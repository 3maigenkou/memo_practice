# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require './memo'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

memo = Memo.new

get '/' do
  redirect to('/memo')
end

get '/memo' do
  @memo_contents = memo.all_memo
  erb :index
end

post '/memo' do
  title = params[:title]
  comment = params[:comment]
  new_memo = memo.create_new_memo(title, comment)
  id = new_memo['id']
  redirect to("/memo/#{id}")
end

get '/memo/new' do
  erb :new
end

get '/memo/:id' do |id|
  @memo = memo.get_memo_detail(id)
  erb :show
end

get '/memo/:id/edit' do |id|
  @memo = memo.get_memo_detail(id)
  erb :edit
end

patch '/memo/:id' do |id|
  title = params[:title]
  comment = params[:comment]
  memo.update_memo(title, comment, id)
  redirect to("/memo/#{id}")
end

delete '/memo/:id' do
  id = params[:id]
  memo.delete_memo(id)
  redirect to('/')
end

not_found do
  erb :not_found
end
