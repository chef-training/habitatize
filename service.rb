require 'sinatra'
require 'rmagick'

get '/' do
  %{
    <html>
      <head></head>
      <body style='background-color: green;'>
        <h1>Meme Green Machine!</h1>

        <form action="/habitatized" method="POST" enctype="multipart/form-data">
          <input type="file" name="file">
          <input type="submit" value="Upload image">
        </form>
      </body>
    </html>
  }
end

set :public_folder, './'

post '/habitatized' do

  tempfile = params[:file][:tempfile]

  puts 'Habitatization started!'

  back = Magick::ImageList.new('back.png')
  subject = Magick::ImageList.new(tempfile.path)

  new_width = 186
  new_height = new_width * subject.rows / subject.columns
  resized_subject = subject.adaptive_resize(new_width, new_height)
  front = Magick::ImageList.new('front.png')


  frames = 20
  movement = 10
  start_position = resized_subject.rows * -1

  animation = Magick::ImageList.new

  frames.times do |index|

    offset = start_position + index * movement

    subject_over_back = back.composite(resized_subject, Magick::CenterGravity, 0, offset, Magick::OverCompositeOp)

    final = subject_over_back.composite(front, Magick::CenterGravity, 0, 0, Magick::OverCompositeOp)

    # final.write("frame_#{index}.gif")
    animation << final

  end

  animation[-1].delay = 200

  animation = animation.optimize_layers(Magick::OptimizePlusLayer)
  animation.write('final.gif')

  "<img src='/final.gif' />"

end
