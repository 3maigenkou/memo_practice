# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'json'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  sort_files = Dir.glob('data/*.json').sort_by { |file| File.birthtime(file) }
  @memo_contents = sort_files.map do |file|
    json_file = File.open(file, 'r')
    JSON.load(json_file)
  end
  erb :index
end

post '/' do
  id = SecureRandom.alphanumeric(10)
  title = params[:title]
  comment = params[:comment]
  File.open("data/#{id}.json", 'w') do |file|
    json = { id: id.to_s, title: title.to_s, comment: comment.to_s }
    JSON.dump(json, file)
  end
  redirect to("/memo/#{id}")
end

get '/new' do
  erb :new
end

get '/memo/:id' do |id|
  @memo = File.open("data/#{id}.json", 'r') do |file|
    JSON.load(file)
  end
  erb :show
end

get '/edit/:id' do |id|
  @memo = File.open("data/#{id}.json", 'r') do |file|
    JSON.load(file)
  end
  erb :edit
end

patch '/edit/:id' do |id|
  title = params[:title]
  comment = params[:comment]
  File.open("data/#{params[:id]}.json", 'w') do |file|
    json = { id: id.to_s, title: title.to_s, comment: comment.to_s }
    JSON.dump(json, file)
  end
  redirect to("/memo/#{id}")
end

delete '/edit/:id' do
  File.delete("data/#{params[:id]}.json")
  redirect to('/')
end

not_found do
  erb :not_found
end
