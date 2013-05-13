# encoding: UTF-8
require "./r2point"
require "./deq"
# Вычисляется сумма углов, под которыми рёбра выпуклой оболочки пересекают заданную прямую.

# Абстрактная фигура
class Figure
  def perimeter; 0.0 end
  def area;      0.0 end
  def sum;   get_sum end
  
  private
  
  def get_sum#создаем метод суммы
	return 0.0 unless self.respond_to? :points #если текущий метод не отвечает points, то мы возвращам 0(нет ребер)
	pts = self.points#возвращает точки выпуклой оболочки
	p pts
	s = 0.0#сумма углов 0
	pts.size.times do |i|#н раз проходим по всем ребрам нашей выпуклой оболочки
    p1,p2 = pts[i-1], pts[i]#находим вершины ребра
	  m = cross_point $points[0], $points[1], p1, p2# находим точку пересечения ребра и прямой
	  if m#если точка пересечения существует (ребра и прямой)
      cp = (m == p1) ? p2 : p1#выбераем точку на ребре не совпадающей с точкой пересечения
      cl = (m == $points[0]) ? $points[1] : $points[0]#выберам точку на прямой не совпадающей с точкой пересечения
      s += angle(cp, m, cl).abs unless cp == cl#вычисляем угл между ребром и премой и добавляем его в сумму
	  end
	end
	s#возвраем сумму всех углов (пробежались в цикле по всем ребрам)
  end
  ##########################################
  # находит уравнение прямой, заданной двумя точками
  def equation_from_segment(p1, p2)
    # Ax + By + C = 0
    x1, y1 = p1.x, p1.y
    x2, y2 = p2.x, p2.y
    
    a = y1 - y2
    b = x2 - x1
    c = x1 * y2 - x2 * y1
    [a, b, c]
  end
  ##############################################3
  # точка пересечения линии AB и отрезка PQ
  def cross_point(a, b, p, q)
    a1, b1, c1 = equation_from_segment(a, b)
    a2, b2, c2 = equation_from_segment(p, q)
   
    d = (a1*b2-a2*b1)
    # Если прямые не перескаются - завершаем работу, отрезки тоже не будут пересекаться
    return false if d == 0
    
    # Находим координаты пересечения прямых
    x = -(c1*b2-c2*b1).to_f / d
    y = -(a1*c2-a2*c1).to_f / d
    
    # Точка пересечения прямых должна принадлежать отрезку PQ
    m = R2Point.new(x, y)
    return false unless m.inside?(p, q)
	  m
  end  
################################################
  # ищем угол В
  def angle (a, b, c)
    # координаты векторов
    ba_x = a.x - b.x
    ba_y = a.y - b.y
    bc_x = c.x - b.x
    bc_y = c.y - b.y
    
    dot_product = ba_x*bc_x + ba_y*bc_y # скалярное произведение
    module_ba = ba_x**2 + ba_y**2
    module_bc = bc_x**2 + bc_y**2
    cos = dot_product / Math.sqrt(module_ba * module_bc)
    cos *= -1 if cos < 0
	  return Math.acos(cos)
  end
  
end

# "Hульугольник"
class Void < Figure
  def add(p)
    Point.new(p)
  end
end

# "Одноугольник"
class Point < Figure
  def initialize(p) 
    @p = p
  end
  def add(q)
    @p == q ? self : Segment.new(@p, q)
  end
end

# "Двуугольник"
class Segment < Figure
  def initialize(p, q) 
    @p, @q = p, q
  end
  def perimeter
    2.0 * @p.dist(@q)
  end
  def add(r) 
    return Polygon.new(@p, @q, r) if R2Point.triangle?(@p, @q, r)
    return Segment.new(@p, r)     if @q.inside?(@p, r)
    return Segment.new(r, @q)     if @p.inside?(r, @q) 
    self
  end
  def points#функция возвращает  
	[@p, @q]#две точки ввиде массива
  end#
end

# "Многоугольник"
  class Polygon < Figure
  attr_reader :perimeter, :area


   def initialize(a, b, c)
    @points    = Deq.new
    @points.push_first(b)
    if b.light?(a,c)
      @points.push_first(a)
      @points.push_last(c)
    else
      @points.push_last(a)
      @points.push_first(c)
    end
  @perimeter = a.dist(b) + b.dist(c) + c.dist(a)
    @area      = R2Point.area(a, b, c).abs
    @sum = get_sum# накапливаем сумму в методе суммы
  end
  
    # добавление новой точки
  def add(t)

    # поиск освещённого ребра
    @points.size.times do
      break if t.light?(@points.last, @points.first)
      @points.push_last(@points.pop_first)
    end

    # хотя бы одно освещённое ребро есть
    if t.light?(@points.last, @points.first)

      # учёт удаления ребра, соединяющего конец и начало дека
      @perimeter -= @points.first.dist(@points.last)
      @area      += R2Point.area(t, @points.last, @points.first).abs

      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
        @area      += R2Point.area(t, p, @points.first).abs
        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
        @area      += R2Point.area(t, p, @points.last).abs
        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
      @points.push_first(t)
    end

    self
  end
  
  def points#
    pts = []#
    
    @points.size.times do#
      p = @points.pop_first#
      pts << p#
      @points.push_last(p)#
    end#
    
    return pts#
  end#
end


