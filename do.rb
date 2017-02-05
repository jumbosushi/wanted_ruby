require 'pry'
require 'indico'
require 'chunky_png'
require 'RMagick'

Indico.api_key =  '48dbdf05055a75d5872b71d412890394'

# Variables 
pic = ChunkyPNG::Image.from_file('./test.png')
wanted_template = ChunkyPNG::Image.from_file('./wanted_template.png')
maxFaceWidth     = 200 
maxFaceHeight    = 200
face_crop       = nil

# ===================
# Helper functions 

# crop needs (x, y, crop_width, crop_height)
def getHeight(top_left, bottom_right) 
  (top_left[1] - bottom_right[1]).abs 
end

def getWidth(top_left, bottom_right) 
  (bottom_right[0] - top_left[0]).abs
end

def isOversize(points, maxFaceWidth) 
  points[0]["bottom_right_corner"][0] - points[0]["top_left_corner"][0] > maxFaceWidth
end

def get_padded_points(top_left, bottom_right, maxFaceWidth)
  width = getWidth(top_left, bottom_right) 
  pad = (maxFaceWidth - width) 
  [ (top_left[0] - pad),
    (top_left[1] - pad).abs,
     (top_left[0] + pad),
     (top_left[1] + pad).abs ]
end

def apply_rect() 
  
end

# ==================
# Logic

face_points =  Indico.facial_localization("./test.png")
top_left_corner =  face_points[0]["top_left_corner"]
bottom_right_corner  =  face_points[0]["bottom_right_corner"]

puts "==== top_left & bottom_right"
print top_left_corner
puts ""
print bottom_right_corner
puts ""

# Crop face_crop
width = getWidth(top_left_corner, bottom_right_corner)
height = getHeight(top_left_corner, bottom_right_corner)
face_crop = pic.crop(top_left_corner[0], top_left_corner[1],
                      width,              height)
puts  "==== Original face_crop"

if isOversize(face_points, maxFaceWidth)
  face_crop  = face_crop.resample_bilinear(maxFaceWidth, maxFaceHeight)
elsif width != maxFaceWidth 
  padded_points =  get_padded_points(top_left_corner,
                                     bottom_right_corner,
                                     maxFaceWidth) 
  face_crop = pic.crop(padded_points[0], padded_points[1],
                      maxFaceWidth,          maxFaceHeight)
end

face_crop.grayscale!
face_crop.border!(3)
face_crop.save('face_crop.png')

wanted_template.compose!(face_crop, 150, 180)
wanted_template.save('combined_pic.png')

canvas = Magick::Image.new(301, 200){self.background_color = 'Transparent'}
gc = Magick::Draw.new
rand_num = rand(1000..10000000).round(-4)
fmt = "%05.2f" % rand_num 
dollar = "$" + fmt
gc.pointsize(40)
gc.text(30,70, dollar.center(14))
gc.draw(canvas)
canvas.write('text.png')

text_pic = ChunkyPNG::Image.from_file('./text.png')
wanted_template.compose!(text_pic, 90, 380)
wanted_template.save('combined_pic.png')
# pic.rect(top_left_corner[0] - 20,
#          top_left_corner[1] - 20,
#          bottom_right_corner[0] + 20,
#          bottom_right_corner[1] + 20,
#          :red )
# pic.save('big_square.png')

