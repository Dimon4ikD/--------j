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
    TkcOval.new(CANVAS, x(p) + 1, y(p) + 1, x(p) - 1, y(p) - 1) {fill("black")}
  end
  # рисование линии
  def TkDrawer.draw_line(p,q)
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill("black")}    
  end
  # Рисование диагонали
  def TkDrawer.draw_diag(p,q)
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill("red")}
  end

  def TkDrawer.line(k,b)
    y0=6.0*k+b
    y1=-6.0*k+b
    TkcLine.new(CANVAS, 6.0, y0, -6.0, y1) {fill("black")}    
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
class Void < Figure
  def draw
    super
    if @a != 0.0
     x0 = 6.0
    x1 = -6.0 
      y0 = (-@b*x0-@c)/@a
      y1 = (-@b*x1-@c)/@a
    else
      y0 = 6.0
      y1 = -6.0
      x0 = -@c/@b
      x1 = -@c/@b
    end
    p1 = R2Point.new(x0, y0)
    p2 = R2Point.new(x1, y1)
    TkDrawer.draw_line(p1,p1)
  end
end
class Point < Figure
  def draw
    super
    TkDrawer.draw_point(@p)
    if @a != 0.0
      x0 = 6.0
      x1 = -6.0 
      y0 = (-@b*x0-@c)/@a
      y1 = (-@b*x1-@c)/@a
    else
      y0 = 6.0
      y1 = -6.0
      x0 = -@c/@b
      x1 = -@c/@b
    end
    p1=R2Point.new(x0,y0)
    p2=R2Point.new(x1,y1)
    TkDrawer.draw_line(p1,p2)
  end
end
class Segment < Figure
  def draw
    super
    TkDrawer.draw_line(@p,@q)
    if @a != 0.0
      x0 = 6.0
      x1 = -6.0 
      y0 = (-@b*x0-@c)/@a
      y1 = (-@b*x1-@c)/@a
    else
      y0 = 6.0
      y1 = -6.0
      x0 = -@c/@b
      x1 = -@c/@b
    end
    p1=R2Point.new(x0,y0)
    p2=R2Point.new(x1,y1)
    TkDrawer.draw_line(p1,p2)
  end
end
class Polygon < Figure
  def draw
    super
    @points.size.times do
      TkDrawer.draw_line(@points.last, @points.first)
      @points.push_last(@points.pop_first)
    end
    if @a != 0.0
      x0 = 6.0
      x1 = -6.0 
      y0 = (-@b*x0-@c)/@a
      y1 = (-@b*x1-@c)/@a
    else
      y0 = 6.0
      y1 = -6.0
      x0 = -@c/@b
      x1 = -@c/@b
    end
    p1=R2Point.new(x0,y0)
    p2=R2Point.new(x1,y1)
    TkDrawer.draw_line(p1,p2)

  end
end
