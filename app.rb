require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/memos' do
  erb :index
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]

  memo = { "id" => SecureRandom.uuid, "title" => @title, "content"=> @content }
  File.open("data/memos_#{memo["id"]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  erb :detail
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  erb :detail
end

get '/memos/:id/edit' do
  erb :edit
end