require 'indico'
require 'chunky_png'

png = ChunkyPNG::Image.new(16, 16, ChunkyPNG::Color::TRANSPARENT)
png[1,1] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
# png.save('filename.png', :interlace => true)

pic = ChunkyPNG::Image.from_file('./test.png')
pic2 = ChunkyPNG::Image.from_file('./test.png')
Indico.api_key =  '48dbdf05055a75d5872b71d412890394'

# single example
face_points =  Indico.facial_localization("./test.png")
top_left_corner =  face_points[0]["top_left_corner"]
bottom_right_corner  =  face_points[0]["bottom_right_corner"]

print top_left_corner
print bottom_right_corner
pic.rect(top_left_corner[0], top_left_corner[1],
                       bottom_right_corner[0], bottom_right_corner[1],
                       :red )
pic.save('square.png')

pic2.rect(top_left_corner[0] - 20,
          top_left_corner[1] - 20,
          bottom_right_corner[0] + 20,
          bottom_right_corner[1] + 20,
          :red )
pic2.save('big_square.png')
