# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  erb :index
end

post '/' do
  memo = { 'id' => SecureRandom.uuid, 'title' => params[:title], 'comment' => params[:comment] }
  File.open("data/memos_#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
  redirect to("/")
end

get '/new' do
  erb :new
end
