# encoding: UTF-8
require "tk"
# Графический интерфейс выпуклой оболочки (модуль) 
module TkDrawer
  # запуск интерпретатора графического интерфейса
  def TkDrawer.create
    CANVAS.pack{padx 5; pady 5}; Thread.new{Tk.mainloop}
  end
  # "стирание" картинки и рисование осей координат  
  def TkDrawer.clean 
    TkcRectangle.new(CANVAS, 0, 0, SIZE, SIZE, "width"=>0) {fill("white")}
    TkcLine.new(CANVAS, 0, SIZE/2, SIZE, SIZE/2) {fill("blue")}
    TkcLine.new(CANVAS, SIZE/2, 0, SIZE/2, SIZE) {fill("blue")}
  end
  # рисование точки
  def TkDrawer.draw_point(p)  
    TkcOval.new(CANVAS, x(p) + 1, y(p) + 1, x(p) - 1, y(p) - 1) {fill("red")}
  end
  # рисование линии
  def TkDrawer.draw_line(p,q,c='black')
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill(c)}   and  TkcOval.new(CANVAS, x(p) + 1, y(p) + 1, x(p) - 5, y(p) - 5) {fill("red")}
  end

  private
  # преобразование координат
  def TkDrawer.x(p)
    SIZE/2 + SCALE*p.x
  end
  def TkDrawer.y(p)
    SIZE/2 - SCALE*p.y
  end
  # Размер окна и коэффициент гомотетии
  SIZE   = 600; SCALE  = 50
  # Корневое окно графического интерфейса
  ROOT   = TkRoot.new{title "Convex"; geometry "#{SIZE+5}x#{SIZE+5}"}
  # Окно для рисования
  CANVAS = TkCanvas.new(ROOT, "height"=>SIZE, "width"=>SIZE)
end

# Определение метода draw для классов выпуклой оболочки
class Figure
  def draw
    TkDrawer.clean
  end
end
class Point < Figure
  def draw
    super
    TkDrawer.draw_point(@p)
  end
end
class Segment < Figure
  def draw
    super
    TkDrawer.draw_line(@p,@q)
  end
end
class Polygon < Figure
  def draw
    super
    k=1
    @points.size.times do 
    c='red' if k%2==0
    c='black' if k%2!=0
      TkDrawer.draw_line(@points.last, @points.first,c)
      k+=1
      @points.push_last(@points.pop_first)
    end
    @points.size.times do 
    cp=@points.pop_first
    nextp=@points.pop_first
    prevp=@points.pop_last
    @points.size.times do 
    TkDrawer.draw_line(cp,@points.first,'blue')
    @points.push_last(@points.pop_first)
    end
    @points.push_last(prevp)
    @points.push_first(nextp)
    @points.push_last(cp)
  end
end
end
