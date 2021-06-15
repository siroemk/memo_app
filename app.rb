# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def memo
    Memo.new
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do

  erb :index
end

post '/memos' do

  redirect to("/memos/:id")
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

patch '/memos/:id/edit' do

  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do

  redirect to('/memos')
end

not_found do
  erb :not_found
end
