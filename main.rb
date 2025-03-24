require 'dxruby'
require_relative 'map'
require_relative 'player'
require_relative 'monster'
require_relative 'astar'
require_relative 'start_screen'

#　BGMを読み込む
bgm = Sound.new("music.wav")

bgm.play

Window.width = 800
Window.height = 600
maze = Maze.new
player = Player.new(64, 64)  # 初始位置可以根据需要调整
monsters = []

game_over = false
game_clear = false
font = Font.new(32)
clear_start_time = nil

start_screen = StartScreen.new
game_started = false

Window.loop do

  unless game_started
    start_screen.draw
    if Input.key_push?(K_RETURN)
      game_started = true
    end
    next
  end

  maze.draw(player.x, player.y)  # 传递玩家的当前位置
  player.update(maze.map, monsters)
  player.draw

  #检查玩家是否有碰到怪物
  monsters.each do |monster|
    monster.update(player, maze.map)
    monster.draw(player)

    if (player.x - monster.x).abs < 32 && (player.y - monster.y).abs < 64
      game_over = true
    end
  end

  if game_over
    # 游戏结束时，屏幕变黑并显示 "GAME OVER"
    Window.draw_box_fill(0, 0, Window.width, Window.height, C_BLACK)
    Window.draw_font(Window.width / 2 - 100, Window.height / 2 - 20, "GAME OVER", font, color: C_WHITE)

    # 按下 ESC 键退出游戏
    if Input.key_push?(K_ESCAPE)
      exit
    end
  end

  # 检查玩家是否在打开的门位置
  if maze.map[player.y / 32][player.x / 32] == 6
    game_clear = true
  end

  if game_clear
    # 游戏清除时，屏幕渐变为白色
    if clear_start_time.nil?
      clear_start_time = Time.now
    end

    elapsed_time = Time.now - clear_start_time
    alpha = [255 * (elapsed_time / 4.0), 255].min  # 计算透明度
    Window.draw_box_fill(0, 0, Window.width, Window.height, [alpha, 255, 255, 255])  # 使用 alpha 绘制白色背景

    if elapsed_time >= 4
      Window.draw_font(Window.width / 2 - 100, Window.height / 2 - 20, "GAME CLEAR", font, color: C_BLACK)
      # 按下 ESC 键退出游戏
      if Input.key_push?(K_ESCAPE)
        exit
      end
    end
  end
end
