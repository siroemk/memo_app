# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require_relative 'memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

memo = Memo.new

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = memo.read_all_memos
  erb :index
end

post '/memos' do
  created_memo = memo.create(params[:title], params[:content])
  id = created_memo['id']
  redirect to("/memos/#{id}")
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = memo.read_a_memo(params[:id])
  @id = params[:id]
  @title = @memo['title']
  @content = @memo['content']
  erb :detail
end

get '/memos/:id/edit' do
  result = memo.read_a_memo(params[:id])
  @id = params[:id]
  @title = result['title']
  @content = result['content']
  erb :edit
end

patch '/memos/:id/edit' do
  @id = params[:id]
  memo.edit(params[:title], params[:content], params[:id])
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  memo.delete(params[:id])
  redirect to('/memos')
end

not_found do
  erb :not_found
end
