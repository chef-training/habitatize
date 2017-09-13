require 'sinatra'
require 'rmagick'
require 'tmpdir'

require_relative 'meme'

get '/' do
  erb :index
end

tmpdir = Dir.mktmpdir('habitatize')
set :public_folder, tmpdir

post '/habitatized' do
  tempfile = params[:file][:tempfile]
  subject = Magick::ImageList.new(tempfile.path)

  result = habitatize_me(subject)

  result.write(File.join(tmpdir,'final.gif'))
  "<img src='/final.gif' />"
end
