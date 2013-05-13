# encoding: UTF-8
require "tk"
# Графический интерфейс выпуклой оболочки (модуль) 
module TkDrawer
  # запуск интерпретатора графического интерфейса
  def TkDrawer.create
    CANVAS.pack{padx 5; pady 5}; Thread.new{Tk.mainloop}
  end
  # стирание и рисование осей координат  
  def TkDrawer.clean 
    # прямоугольник
    TkcRectangle.new(CANVAS, 0, 0, SIZE, SIZE, "width"=>0) {fill("white")}
    # отрезки
    TkcLine.new(CANVAS, 0, SIZE/2, SIZE, SIZE/2) {fill("blue")}
    TkcLine.new(CANVAS, SIZE/2, 0, SIZE/2, SIZE) {fill("blue")}
  end
  # рисование точки
  def TkDrawer.draw_point(p)
    # овал
    TkcOval.new(CANVAS, x(p) + 1, y(p) + 1, x(p) - 1, y(p) - 1) {fill("black")}
  end
  # рисование линии
  def TkDrawer.draw_line(p,q,c="black")
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill(c)}    
  end
  # рисование многоугольника
  def TkDrawer.draw_lines(points)
    for i in -1...points.size-1
      TkDrawer.draw_line(points[i], points[i+1])
    end
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
