require "./r2point"
require "./deq"

# Абстрактная фигура
class Figure
  def perimeter; 0.0 end
  def area;      0.0 end
  def func;     0   end
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
  def func; @p.lies_on1?($a, $b, $c) ? 1 : 0 end #Точка на прямой или нет?
end

# "Двуугольник"
class Segment < Figure
  def initialize(p, q) 
    @p, @q = p, q
  end
  def perimeter
    2.0 * @p.dist(@q)
  end
  def func
    if R2Point.crossing_line?($a, $b, $c,@p,@q) #Ребро пересекает прямую
      1
    elsif @p.lies_on1?($a, $b, $c) and @q.lies_on1?($a, $b, $c) #Ребро лежит на прямой
      "infinity"
    else
      0
    end
  end

  def add(r) 
    return Polygon.new(@p, @q, r) if R2Point.triangle?(@p, @q, r)
    return Segment.new(@p, r)     if @q.inside?(@p, r)
    return Segment.new(r, @q)     if @p.inside?(r, @q) 
    self
  end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area, :func

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
    @func = "infinity" if (a.lies_on1?($a, $b, $c) and b.lies_on1?($a, $b, $c)) or (b.lies_on1?($a, $b, $c) and c.lies_on1?($a, $b, $c)) or (c.lies_on1?($a, $b, $c) and a.lies_on1?($a, $b, $c)) #Одно из ребер лежит на прямой(old version) 
    @func = 0 if @func != "infinity" #Если ни одно ребро не лежит на прямой, то считаем количество пересечений:
    @func += 1 if R2Point.crossing_line?($a, $b, $c, a, b) and @func != "infinity"
    @func += 1 if R2Point.crossing_line?($a, $b, $c, b, c) and @func != "infinity"
    @func += 1 if R2Point.crossing_line?($a, $b, $c, c, a) and @func != "infinity"
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
      if R2Point.lies_on?($a, $b, $c, @points.first, @points.last) and @func == "infinity" 
        @func = 0 #Удалилось ребро, лежащее на прямой
      elsif R2Point.crossing_line?($a, $b, $c, @points.first, @points.last)
        @func -= 1 if @func != "infinity" #Удалилось ребро, пересекающее прямую
      end 
      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
        @area      += R2Point.area(t, p, @points.first).abs
        if R2Point.lies_on?($a, $b, $c, @points.first, p) and @func == "infinity"
          @func = 0 #Удалилось ребро, лежащее на прямой
        elsif R2Point.crossing_line?($a, $b, $c, @points.first, p)
          @func -= 1 if @func != "infinity" #Удалилось ребро, пересекающее прямую
        end 

        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
        @area      += R2Point.area(t, p, @points.last).abs
        if R2Point.lies_on?($a, $b, $c, @points.last, p) and @func == "infinity"
          @func = 0 #Удалилось ребро, лежащее на прямой
        elsif R2Point.crossing_line?($a, $b, $c, @points.last, p)
          @func -= 1 if @func != "infinity" #Удалилось ребро, пересекающее прямую
        end 

        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер 
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
      if @func != "infinity" #Проверяем ребра, если есть нужда
        @func = "infinity" if R2Point.lies_on?($a, $b, $c, @points.last, t) or R2Point.lies_on?($a, $b, $c, @points.first, t) 
        @func += 1 if R2Point.crossing_line?($a, $b, $c, @points.last, t) and @func != "infinity"
        @func += 1 if R2Point.crossing_line?($a, $b, $c, @points.first, t) and @func != "infinity"
      end
      @points.push_first(t)
    end

    self
  end
end
