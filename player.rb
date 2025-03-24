# player.rb

require 'dxruby'

class Player
  attr_accessor :image, :x, :y

  def initialize(x, y)
    @image_right = Image.load("image/player_right.png")
    @image_left = Image.load("image/player_left.png")
    @key_image = Image.load("image/key.png")
    @image = @image_right  # 初始方向为右
    @x = x
    @y = y
    @has_key = false
    @inventory = []
    @inventory_open = false
    @font = Font.new(24)
  end

  def update(map, monsters)
    new_x = @x
    new_y = @y

    if Input.key_down?(K_UP)
      new_y -= 4
    elsif Input.key_down?(K_DOWN)
      new_y += 4
    elsif Input.key_down?(K_LEFT)
      new_x -= 4
      @image = @image_left
    elsif Input.key_down?(K_RIGHT)
      new_x += 4
      @image = @image_right
    end

    if can_move?(new_x, new_y, map)
      @x = new_x
      @y = new_y
    end

    handle_interaction(map, monsters)

    #打开物品袋
    if Input.key_push?(K_B)
      @inventory_open = !@inventory_open
    end
  end

  def draw
    Window.draw(@x, @y, @image)
    draw_inventory if @inventory_open
  end

  private

  def can_move?(x, y, map)
    player_width = 32
    player_height = 64
    cell_size = 32
  
    # 检查四个角是否会碰撞
    [[x, y], [x + player_width - 1, y], [x, y + player_height - 1], [x + player_width - 1, y + player_height - 1]].each do |px, py|
      map_x = px / cell_size
      map_y = py / cell_size
  
      # 检查是否超出地图范围
      if map_x >= map[0].size || map_y >= map.size
        return false
      end
  
      # 检查是否碰到任何非零元素
      if map[map_y][map_x] == 1
        return false
      end
    end
  
    true
  end

  def handle_interaction(map, monsters)
    cell_size = 32
    map_x = @x / cell_size
    map_y = @y / cell_size

    # 检查玩家是否面对机关
    if map[map_y][map_x + 1] == 3 && Input.key_push?(K_G)
      map[map_y][map_x + 1] = 4  # 机关变成钥匙
      create_monster(monsters, map)
    end

    # 检查玩家是否在钥匙位置并按下 F 键
    if map[map_y][map_x + 1] == 4 && Input.key_push?(K_F)
      @has_key = true  # 玩家捡起钥匙
      map[map_y][map_x + 1] = 0  # 地图上移除钥匙
      @inventory << @key_image # 将钥匙添加到物品袋
    end

    # 检查玩家是否在门前并按下 F 键
    if map[map_y][map_x + 1] == 5 && Input.key_push?(K_F)
      if @inventory.include?(@key_image)
        map[map_y][map_x + 1] = 6  # 将门变为打开状态
        @inventory.delete(@key_image)  # 移除钥匙
      end
    end
  end

  def create_monster(monsters, map)
    cell_size = 32
    monster_image = Image.load("image/monster1.png")
    monster_speed = 5
  
    # 在玩家前方3格处生成怪物
    if @image == @image_right
      monster_x = @x + 3 * cell_size
      monster_y = @y
    elsif @image == @image_left
      monster_x = @x - 3 * cell_size
      monster_y = @y
    else
      return
    end
  
    if can_move?(monster_x, monster_y, map)
      monsters << Monster.new(monster_x, monster_y, monster_image, monster_speed)
    end
  end
  

  def draw_inventory
    Window.draw_box_fill(10, 10, 210, 210, [0, 0, 0, 200])  # 绘制一个黑色的半透明背景
    Window.draw_font(20, 20, "Inventory", @font, color: C_WHITE)

    @inventory.each_with_index do |item, index|
      Window.draw(20, 50 + index * 40, item)
    end
  end

end
