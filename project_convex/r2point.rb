# Точка (Point) на плоскости (R2)
class R2Point 
  attr_reader :x, :y

  # конструктор
  def initialize(x = input("x"), y = input("y")) 
    @x, @y = x, y
  end
  # площадь треугольника (метод класса)
  def R2Point.area(a, b, c) 
    0.5*((a.x-c.x)*(b.y-c.y)-(a.y-c.y)*(b.x-c.x))
  end
  # лежат ли точки на одной прямой? (метод класса)
  def R2Point.triangle?(a, b, c) 
    area(a, b, c) != 0.0
  end
  # расстояние до другой точки
  def dist(other) 
    Math.sqrt((other.x-@x)**2 + (other.y-@y)**2)
  end
  # лежит ли точка внутри "стандартного" прямоугольника?
  def inside?(a, b) 
    ((a.x <= @x and @x <= b.x) or (a.x >= @x and @x >= b.x)) and
      ((a.y <= @y and @y <= b.y) or (a.y >= @y and @y >= b.y)) 
  end
  # освещено ли из данной точки ребро (a,b)?
  def light?(a, b) 
    s = R2Point.area(a, b, self)
    s < 0.0 or (s == 0.0 and !inside?(a, b))
  end
  # совпадает ли точка с другой?
  def == (other) 
    @x == other.x and @y == other.y
  end

  def R2Point.crossing_line?(a, b, c, p1, p2) #Ребро из двух точек пересекает прямую тогда, когда его вершины лежат по разные стороны от прямой или только одна из вершин лежит на прямой
     (p1.y > ((b/a)*p1.x-(c/a)) and p2.y < ((b/a)*p2.x-(c/a))) or (p2.y > ((b/a)*p2.x-(c/a)) and p1.y < ((b/a)*p1.x-(c/a))) or (p1.y == ((b/a)*p1.x-(c/a)) and p2.y != ((b/a)*p2.x-(c/a))) or (p2.y == ((b/a)*p2.x-(c/a)) and p1.y != ((b/a)*p1.x-(c/a)))
  end

  def lies_on1?(a, b, c) #Лежит ли точка на прямой?
    @y == ((b/a)*@x-(c/a))
  end

def R2Point.lies_on?(a, b, c, p1, p2) #Лежит ли ребро на прямой?(обе вершины на прямой)
    p1.y == ((b/a)*p1.x-(c/a)) and p2.y == ((b/a)*p2.x-(c/a)) 
  end

  


  private
  def input(prompt)
    print "#{prompt} -> "
    readline.to_f
  end
end
