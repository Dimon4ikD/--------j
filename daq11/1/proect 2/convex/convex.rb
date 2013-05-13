# encoding: UTF-8
require "./r2point"
require "./deq"

# Абстрактная фигура
class Figure
  def perimeter; 0.0 end
  def area;      0.0 end
  def sins;      0.0 end
  def sumx;      0.0 end
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
  def sins	
	Math.sin(@p.x * @p.y) 
  end
  def sumx
		@sumx = @p.x
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
  def sins	
	(Math.sin(@p.x * @p.y) + Math.sin(@q.x * @q.y)) / 2.0
  end
  def sumx
   @p.x + @q.x
  end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area

  def sins()
	@sins / @points.size
  end

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
    @sins = (Math.sin(a.x * a.y) + Math.sin(b.x * b.y) + Math.sin(c.x * c.y))
    @sumx=a.x+b.c+c.x
    end
    def sumx
    @sum
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
			@sumx -= @points.first.(@x)
      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
	@area      += R2Point.area(t, p, @points.first).abs
        @sins 	   -= Math.sin(p.x + p.y)
        p = @points.pop_first
      end
      @points.push_first(p)
      @sins 	   += Math.sin(p.x + p.y)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
	@area      += R2Point.area(t, p, @points.last).abs
        @sins 	   -= Math.sin(p.x + p.y)
        p = @points.pop_last
      end
      @points.push_last(p)
      @sins 	   += Math.sin(p.x + p.y)

      # добавление двух новых рёбер 
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
      @points.push_first(t)
      @sins 	   -= Math.sin(t.x + t.y)
    end

    self
  end
end
