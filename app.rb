# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos =
    Dir.glob('data/*').map do |file|
      memo = File.open(file)
      JSON.parse(memo.read)
    end
  @memos = @memos.sort_by { |file| file['time'] }
  erb :index
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]

  memo = { 'id' => SecureRandom.uuid, 'title' => @title, 'content' => @content, 'time' => Time.now }
  File.open("data/memos_#{memo['id']}.json", 'w') { |file| JSON.dump(memo, file) }
  redirect to("/memos/#{memo['id']}")
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  if File.exist?("data/memos_#{params[:id]}.json")
    memo = File.open("data/memos_#{params[:id]}.json") { |file| JSON.parse(file.read) }
  else
    redirect to('not_found')
  end
  @title = memo['title']
  @content = memo['content']
  @id = memo['id']
  erb :detail
end

get '/memos/:id/edit' do
  if File.exist?("data/memos_#{params[:id]}.json")
    memo = File.open("data/memos_#{params[:id]}.json") { |file| JSON.parse(file.read) }
  else
    redirect to('not_found')
  end
  @title = memo['title']
  @content = memo['content']
  @id = memo['id']
  erb :edit
end

patch '/memos/:id/edit' do
  File.open("data/memos_#{params[:id]}.json", 'w') do |file|
    memo = { 'id' => params[:id], 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
    JSON.dump(memo, file)
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  File.delete("data/memos_#{params[:id]}.json")
  redirect to('/memos')
end

not_found do
  erb :not_found
end