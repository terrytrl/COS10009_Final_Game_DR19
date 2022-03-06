require 'gosu'

# The following code is used to generate a tile map from a .txt file.

# def setup_game_map(filename)
#   game_map = GameMapp.new
#   game_map.time_set = Gosu::Image.load_tiles("FILEPATH", 60, 60, :tileable)
#
#   gem_img = Gosu::Image.new("FILEPATH")
#   gem_map.gems = []
#
#   lines = File.readlines(filename).map { |line| line.chomp }
#   gem_map.height = line.size
#   game_map.width = lines[0].size
#
#   Array.new(game_map.hight) do |y|
#     case lines [y] [x, 1]
#     when '"'
#       Tiles::Grass
#     when '#'
#       Tiles::Earth
#     when 'x'
#       game_map.gems.push(setup_gem(gem_img, x * 50 + 25, y * 50 + 25))
#       nil
#     else
#       nil
#     end
#   end
# end
#
# def draw_game_map(game_map)
#   game_map.height.times do |y|
#     game_map.width.times do |x|
#       tile = game_map.tiles[x][y]
#       if tile
#         # draw a tile with an offset (tile images have some overlap)
#         # Scrolling is implemented here just as in the game objects
#         game_map.tile_set[tile].draw(x * 50 - 5, y * 50 - 5, 0)
#       end
#     end
#   end
#   game_map.gems.each { |c| draw_gem(c) }
# end
#
# def draw_gem(gem)
#   # Draw, rotating
#   gem.image.draw_rot(gem.x, gem.y, 0, 25 * Math.sin(Gosu.milliseconds / 133.7))
# end
#
# def collect_gems(player, gems)
#   gems.reject! do |c|
#     (c.x - player.x).abs < 50 and (c.y - player.y).abs < 50
#   end
# end


# # Sound implimentation
# # Stored as global variables that can be called.
# @yuk = Gosu::Sample.new("media/Yuk.wav")
# @yum = Gosu::Sample.new("media/Yum.wav")
# # to play call the variable with .play
# @yum.play

# to play a song
# @song = Gosu::Song.new(album.tracks[track].location)
# @song.play(false)
# can also
# @song.pause
      # .paused?
      # .play(looping = false)
      # .playing?
      # .stop



      module ZOrder
        BACKGROUND, MIDDLE, TOP = *0..2
      end

      WIDTH = 400
      HEIGHT = 500
      SHAPE_DIM = 50


      # Instructions:
      # Fix the following code so that:
      # 1. The shape also can be moved up and down
      # 2. the shape does not move out of the window area

class GameWindow < Gosu::Window

  def initialize
    super WIDTH, HEIGHT, false
    self.caption = "Shape Moving"

    @shape_y = HEIGHT / 2
    @shape_x = WIDTH / 2
  end

        # Put any work you want done in update
        # This is a procedure i.e the return value is 'undefined'
  def update

    if button_down?(Gosu::KbRight) && (@shape_x != WIDTH)
      if @shape_x != (WIDTH - SHAPE_DIM)
        @shape_x += 3
      end
    end

    if button_down?(Gosu::KbLeft) && (@shape_x != WIDTH - WIDTH)
      if @shape_x != (WIDTH + SHAPE_DIM) && (@shape_x > 0)
        @shape_x -= 3
      end
    end

    if button_down?(Gosu::KbUp) && (@shape_y != HEIGHT - HEIGHT)
      if @shape_x != (HEIGHT + SHAPE_DIM) && (@shape_y > 0)
        @shape_y -= 3
      end
    end

    if button_down?(Gosu::KbDown)
      if @shape_y < HEIGHT - SHAPE_DIM && (@shape_y != HEIGHT)
        @shape_y += 3
      end
    end

  end


  def draw
    Gosu.draw_rect(@shape_x, @shape_y, SHAPE_DIM, SHAPE_DIM, Gosu::Color.argb(100, 100, 100), ZOrder::TOP, mode=:default)

  end
end


window = GameWindow.new
window.show
