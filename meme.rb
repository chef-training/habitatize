require 'rmagick'

puts 'Habitatization started!'

back = Magick::ImageList.new('back.png')
subject = Magick::ImageList.new('subject.png')

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

  final.write("frame_#{index}.gif")
  animation << final

end

animation[-1].delay = 200

animation = animation.optimize_layers(Magick::OptimizePlusLayer)
animation.write('final.gif')

puts 'Habitatization complete!'
