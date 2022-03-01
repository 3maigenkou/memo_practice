# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end


class Memo
  def initialize
    @conn = PG.connect(dbname: 'memotest')
  end

  def get_all_memo
    @conn.exec('SELECT * FROM memo ORDER BY id')
  end

  def create_new_memo(title,comment)
    @conn.exec("INSERT INTO memo (title, comment) VALUES ('#{title}', '#{comment}') RETURNING id").first
  end

  def get_memo_detail(id)
    @conn.exec("SELECT * FROM memo WHERE id = '#{id}'").first
  end

  def update_memo(title,comment,id)
    @conn.exec("UPDATE memo SET title = '#{title}', comment = '#{comment}' WHERE id ='#{id}'")
  end

  def delete_memo(id)
    @conn.exec("DELETE FROM memo WHERE id ='#{id}'")
  end
end

memo = Memo.new

get '/' do
  @memo_contents = memo.get_all_memo
  erb :index
end

post '/' do
  title = params[:title]
  comment = params[:comment]
  new_memo = memo.create_new_memo(title,comment)
  id = new_memo['id']
  redirect to("/memo/#{id}")
end

get '/new' do
  erb :new
end

get '/memo/:id' do |id|
  @memo = memo.get_memo_detail(id)
  erb :show
end

get '/edit/:id' do |id|
  @memo = memo.get_memo_detail(id)
  erb :edit
end

patch '/edit/:id' do |id|
  title = params[:title]
  comment = params[:comment]
  memo.update_memo(title,comment,id)
  redirect to("/memo/#{id}")
end

delete '/edit/:id' do
  id = params[:id]
  memo.delete_memo(id)
  redirect to('/')
end

not_found do
  erb :not_found
end
