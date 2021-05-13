require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/memos' do
  @memos =
    Dir.glob('data/*').map do |file|
      File.open(file) do |memo|
        JSON.load(memo)
      end
    end
  @memos = @memos.sort_by { |file| file['time'] }
  erb :index
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]
  @time = Time.now

  memo = { "id" => SecureRandom.uuid, "title" => @title, "content"=> @content, "time" => @time }
  File.open("data/memos_#{memo["id"]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to("/memos/#{memo["id"]}")
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memo =
    File.open("data/memos_#{params['id']}.json") do |file|
      JSON.load(file)
    end
  @title = memo["title"]
  @content = memo["content"]
  erb :detail
end

get '/memos/:id/edit' do
  memo =
  File.open("data/memos_#{params['id']}.json") do |file|
    JSON.load(file)
  end
  @title = memo["title"]
  @content = memo["content"]
  erb :edit
end