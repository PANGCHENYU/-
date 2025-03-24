# map.rb

require 'dxruby'

class Maze
  attr_accessor :gray_image, :brown_image, :map

  def initialize
    @kabe1_image = Image.load("image/kabe1.png")
    @brown_image = Image.load("image/deng.png")
    @mechanism_image = Image.load("image/mechanism.png")
    @key_image = Image.load("image/key.png")
    @door_image = Image.load("image/door.png")
    @door_open_image = Image.load("image/door_open.png")
    @dark_image = Image.new(32, 32, C_BLACK) # 黑色方块
    @map = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ]
    @map[14][21] = 5  # 在地图右下角设置一个门
  end

  def draw(player_x, player_y)
    @map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        case cell
        when 1
          Window.draw(x * 32, y * 32, @kabe1_image)
        when 2
          Window.draw(x * 32, y * 32, @brown_image)
        when 3
          Window.draw(x * 32, y * 32, @mechanism_image)
        when 4
          Window.draw(x * 32, y * 32, @key_image)
        when 5
          Window.draw(x * 32, y * 32, @door_image)
        when 6
          Window.draw(x * 32, y * 32, @door_open_image)
        end

        # 计算玩家与当前格子的曼哈顿距离
        distance = (player_x / 32 - x).abs + (player_y / 32 - y).abs
        if distance > 3
          Window.draw(x * 32, y * 32, @dark_image)
        end
      end
    end
  end
end
