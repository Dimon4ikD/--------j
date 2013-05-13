# encoding: UTF-8
require "../common/polyedr"

# Одномерный отрезок
class Segment
  # начало и конец отрезка (числа)
  attr_reader :beg, :end
  def initialize(b, e)
    @beg, @end = b, e
  end
  # отрезок вырожден?
  def degenerate? 
    @beg >= @end
  end
  # пересечение с отрезком
  def intersect!(other) 
    @beg = other.beg if other.beg > @beg
    @end = other.end if other.end < @end
    self
  end
  # разность отрезков
  def subtraction(other)
    [Segment.new(@beg, @end < other.beg ? @end : other.beg),
     Segment.new(@beg > other.end ? @beg : other.end, @end)]
  end
end

# Ребро полиэдра
class Edge 
  # Начало и конец стандартного одномерного отрезка
  SBEG = 0.0; SEND = 1.0
  # начало и конец ребра (точки в R3), список "просветов"
  attr_reader :beg, :end, :gaps
  def initialize(b, e)
    @beg, @end, @gaps = b, e, [Segment.new(SBEG, SEND)]
  end  
  # учёт тени от одной грани
  def shadow(facet)
    return if facet.vertical?
    # нахождение одномерной тени на ребре
    shade = Segment.new(SBEG, SEND)
    facet.vertexes.zip(facet.v_normals) do |arr|
     shade.intersect!(cross(arr[0], arr[1]))
      return if shade.degenerate? 
    end
    shade.intersect!(cross(facet.vertexes[0], facet.h_normal))
    return if shade.degenerate?    
    # преобразование списка "просветов", если тень невырождена
    @gaps = @gaps.map do |s|
      s.subtraction(shade)
    end.flatten.delete_if{|s| s.degenerate?}
  end
  # преобразование одномерных координат в трёхмерные
  def r3(t)
    @beg*(SEND-t) + @end*t
  end

  private
  # пересечение ребра с полупространством, задаваемым точкой (a)
  # на плоскости и вектором внешней нормали (n) к ней
  def cross(a, n)
    f0, f1 = n.s(@beg - a), n.s(@end - a)
    return Segment.new(SEND, SBEG) if f0 >= 0.0 and f1 >= 0.0
    return Segment.new(SBEG, SEND) if f0 < 0.0 and f1 < 0.0
    x = - f0 / (f1 - f0)
    f0 < 0.0 ? Segment.new(SBEG, x) : Segment.new(x, SEND)
  end
end    

# Грань полиэдра
class Facet 
  # "вертикальна" ли грань?
  def vertical?
    h_normal.s(Polyedr::V) == 0.0
  end
  # нормаль к "горизонтальному" полупространству
  def h_normal
    n = (@vertexes[1]-@vertexes[0]).v(@vertexes[2]-@vertexes[0])
    n.s(Polyedr::V) < 0.0 ? n*(-1.0) : n
  end
  # нормали к "вертикальным" полупространствам, причём k-я из них
  # является нормалью к гране, которая содержит ребро, соединяющее
  # вершины с индексами k-1 и k
  def v_normals
    (0...@vertexes.size).map do |k|
      n = (@vertexes[k] - @vertexes[k-1]).v(Polyedr::V)
      n.s(@vertexes[k-1] - center) < 0.0 ? n*(-1.0) : n
    end
  end

  private
  # центр грани
  def center
    @vertexes.inject(R3.new(0.0,0.0,0.0)){|s,v| s+v}*(1.0/@vertexes.size)
  end
end

# Полиэдр
class Polyedr 
  # вектор проектирования
  V = R3.new(0.0,0.0,1.0)

  def draw
    TkDrawer.clean
    edges.each do |e|
      facets.each{|f| e.shadow(f)}
      e.gaps.each{|s| TkDrawer.draw_line(e.r3(s.beg), e.r3(s.end))}
    end
  end
end
