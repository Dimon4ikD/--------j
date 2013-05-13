require "./r2point"
require "./deq"

# Абстрактная фигура
class Figure
  def initialize(a = input("a"),b = input("b"),c = input("c"))
    @a, @b, @c = a, b, c
  end
  def perimeter; 0.0 end
  def area;      0.0 end
  def dist_to_line; 0.0 end
end


# "Hульугольник"
class Void < Figure
  attr_reader :a, :b, :c
  def add(p)
    Point.new(p,@a,@b,@c)
  end
  #private
  def input(prompt)
    print "#{prompt} -> "
    readline.to_f
  end
  #public
end

# "Одноугольник"
class Point < Figure
  def initialize(p,a,b,c) 
    @p,@a,@b,@c = p,a,b,c
  end
  def dist_to_line
    @p.distline(@a,@b,@c)
  end
  def add(q)
    @p == q ? self : Segment.new(@p, q,@a,@b,@c)
  end
end

# "Двуугольник"
class Segment < Figure
  def initialize(p, q, a, b, c) 
    @p, @q, @a, @b, @c = p, q, a, b, c
  end
  def perimeter
    2.0 * @p.dist(@q)
  end
  def dist_to_line
    if (@a*@p.y+@b*@p.x+@c < 0.0 and @a*@q.y+@b*@q.x+@c > 0.0) or (@a*@p.y+@b*@p.x+@c > 0.0 and @a*@q.y+@b*@q.x+@c < 0.0) 
      @dist = 0.0
    else
      @p.distline(@a,@b,@c) <= @q.distline(@a,@b,@c) ? @dist = @p.distline(@a,@b,@c) : @q.distline(@a,@b,@c)
    end
  end
  def add(r) 
    return Polygon.new(@p, @q, r, @a, @b, @c, @dist) if R2Point.triangle?(@p, @q, r)
    return Segment.new(@p, r, @a, @b, @c)     if @q.inside?(@p, r)
    return Segment.new(r, @q, @a, @b, @c)     if @p.inside?(r, @q) 
    self
  end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area, :dist_to_line

  def initialize(a, b, c, a1, b1, c1, dist)
    @a, @b, @c, @dist = a1, b1, c1, dist
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
    if @dist == 0.0
      @dist_to_line = @dist
    else
      if (@a*a.y+@b*a.x+@c < 0.0 and @a*b.y+@b*b.x+@c > 0.0) or (@a*a.y+@b*a.x+@c > 0.0 and @a*b.y+@b*b.x+@c < 0.0) or (@a*a.y+@b*a.x+@c < 0.0 and @a*c.y+@b*c.x+@c > 0.0) or (@a*a.y+@b*a.x+@c > 0.0 and @a*c.y+@b*c.x+@c < 0.0) or (@a*b.y+@b*b.x+@c < 0.0 and @a*c.y+@b*c.x+@c > 0.0) or (@a*b.y+@b*b.x+@c > 0.0 and @a*c.y+@b*c.x+@c < 0.0) 
        @dist_to_line = 0.0
      else
        atl=a.distline(@a,@b,@c)
        btl=b.distline(@a,@b,@c)
        ctl=c.distline(@a,@b,@c)
        arr=[atl,btl,ctl]
        @dist_to_line = arr.min
      end
    end
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
        if @dist_to_line != 0
          if p.distline(@a,@b,@c) <= @dist_to_line
            @dist_to_line = p.distline(@a,@b,@c)
          end
        end
        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
        @area      += R2Point.area(t, p, @points.last).abs
        if @dist_to_line != 0
          if p.distline(@a,@b,@c) <= @dist_to_line
            @dist_to_line = p.distline(@a,@b,@c)
          end
        end

        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер 
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
      @points.push_first(t)
      if @dist_to_line == 0.0
        @dist_to_line = 0.0
      else
        if (@a*t.y+@b*t.x+@c < 0.0 and @a*@points.last.y+@b*@points.last.x+@c > 0.0) or (@a*t.y+@b*t.x+@c > 0.0 and @a*@points.last.y+@b*@points.last.x+@c < 0.0) or (@a*t.y+@b*t.x+@c < 0.0 and @a*@points.first.y+@b*@points.first.x+@c > 0.0) or (@a*t.y+@b*t.x+@c > 0.0 and @a*@points.first.y+@b*@points.first.x+@c < 0.0)
          @dist_to_line = 0.0
        else
          ttl=t.distline(@a,@b,@c)
          ltl=@points.last.distline(@a,@b,@c)
          ftl=@points.first.distline(@a,@b,@c)
          arr=[ttl,ltl,ftl]
          @dist_to_line = arr.min
        end
      end
    end

    self
  end
end
