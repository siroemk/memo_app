require 'sinatra'
require 'sinatra/reloader'

get '/memos' do
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/id' do
  @title = 'タイトルです'
  @content = '内容です'
  erb :detail
end

get '/memos/edit' do
  @title = 'タイトルです'
  @content = '内容です'
  erb :edit
end