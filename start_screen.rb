require 'dxruby'

class StartScreen
  def initialize
    @font_title = Font.new(64)
    @font_text = Font.new(32)
    @player_image = Image.load("image/player_left.png")
  end

  def draw
    Window.draw_font(Window.width / 2 - 130, Window.height * 2 / 11, "幽霊迷宮", @font_title, color: C_WHITE)
    Window.draw(Window.width / 2 - @player_image.width / 2, Window.height * 4 / 11 - @player_image.height / 2, @player_image)
    Window.draw_font(Window.width / 2 - 150, Window.height * 5 / 11, "Fキーでインタラクト", @font_text, color: C_WHITE)
    Window.draw_font(Window.width / 2 - 150, Window.height * 6 / 11, "Gキーでアイテムを拾う", @font_text, color: C_WHITE)
    Window.draw_font(Window.width / 2 - 150, Window.height * 7 / 11, "Bキーでバッグを開く", @font_text, color: C_WHITE)
    Window.draw_font(Window.width / 2 - 50, Window.height * 9 / 11, "Enter開始", @font_text, color: C_WHITE)
  end
end
