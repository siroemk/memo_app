# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  connection = PG.connect(dbname: 'memos')
  @memos = connection.exec('SELECT * FROM t_memos')
  erb :index
end

post '/memos' do
  connection = PG.connect(dbname: 'memos')
  title = params[:title]
  content = params[:content]
  memo = connection.exec('INSERT INTO t_memos (title, content) VALUES ($1, $2) RETURNING id' , [title, content])
  id = memo.first['id']
  redirect to("/memos/#{id}")
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  connection = PG.connect(dbname: 'memos')
  id = params[:id]
  @memo = connection.exec('SELECT * FROM t_memos WHERE id = $1', [id]).first
  @id = params[:id]
  erb :detail
end

get '/memos/:id/edit' do
  connection = PG.connect(dbname: 'memos')
  id = params[:id]
  memo = connection.exec('SELECT * FROM t_memos WHERE id = $1', [id]).first
  @title = memo['title']
  @content = memo['content']
  @id = params[:id]
  erb :edit
end

patch '/memos/:id/edit' do
  connection = PG.connect(dbname: 'memos')
  id = params[:id]
  title = params[:title]
  content = params[:content]
  @id = params[:id]
  connection.exec('UPDATE t_memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  redirect to("/memos/#{id}")
end

delete '/memos/:id' do
  connection = PG.connect(dbname: 'memos')
  id = params[:id]
  connection.exec('DELETE FROM t_memos WHERE id = $1', [id])
  redirect to('/memos')
end

not_found do
  erb :not_found
end
