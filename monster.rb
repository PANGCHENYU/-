require_relative 'astar'

class Monster
  attr_accessor :x, :y, :image, :speed

  def initialize(x, y, image, speed)
    @x = x
    @y = y
    @image = image
    @speed = speed
    @astar = nil
    @path = []
    @dark_image = Image.new(32, 32, C_BLACK)  # 全黑色方块
  end

  def update(player, map)
    if @astar.nil?
      @astar = AStar.new(map)
    end

    # 重新计算路径
    if @path.empty?
      start_node = [@y / 32, @x / 32]
      end_node = [player.y / 32, player.x / 32]
      @path = @astar.search(start_node, end_node)
    end

    move_along_path
  end

  def draw(player)
    distance = (player.x / 32 - @x / 32).abs + (player.y / 32 - @y / 32).abs
    if distance <= 3
      Window.draw(@x, @y, @image)
    else
      Window.draw(@x, @y, @dark_image)
    end
  end

  private

  def move_along_path
    return if @path.empty?

    next_node = @path.first
    target_x = next_node[1] * 32
    target_y = next_node[0] * 32

    dx = target_x - @x
    dy = target_y - @y

    if dx.abs < @speed
      @x = target_x
    else
      @x += (dx <=> 0) * @speed
    end

    if dy.abs < @speed
      @y = target_y
    else
      @y += (dy <=> 0) * @speed
    end

    # 如果已经到达节点位置，则从路径中移除该节点
    if @x == target_x && @y == target_y
      @path.shift
    end
  end
end
