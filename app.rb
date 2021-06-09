# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def get_file_path(id)
    "data/memos_#{id}.json"
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Dir.glob('data/*').map { |file| JSON.parse(File.open(file).read) }
  @memos = @memos.sort_by { |file| file['time'] }
  erb :index
end

post '/memos' do
  memo = { 'id' => SecureRandom.uuid, 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
  File.open("data/memos_#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
  redirect to("/memos/#{memo['id']}")
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  file_path = get_file_path(params[:id])
  File.exist?(file_path) ? (memo = File.open(file_path) { |file| JSON.parse(file.read) }) : (redirect to('not_found'))
  @title = memo['title']
  @content = memo['content']
  @id = memo['id']
  erb :detail
end

get '/memos/:id/edit' do
  file_path = get_file_path(params[:id])
  File.exist?(file_path) ? (memo = File.open(file_path) { |file| JSON.parse(file.read) }) : (redirect to('not_found'))
  @title = memo['title']
  @content = memo['content']
  @id = memo['id']
  erb :edit
end

patch '/memos/:id/edit' do
  file_path = get_file_path(params[:id])
  File.open(file_path, 'w') do |file|
    memo = { 'id' => params[:id], 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
    JSON.dump(memo, file)
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  file_path = get_file_path(params[:id])
  File.delete(file_path)
  redirect to('/memos')
end

not_found do
  erb :not_found
end
