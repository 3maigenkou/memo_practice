# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  erb :index
end

get '/new' do
  erb :new
end

get '/show' do
  erb :show
end

get '/edit' do
  erb :edit
end
