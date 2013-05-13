# encoding: UTF-8
require 'test/unit'
require "../shadow/polyedr"

DELTA = 1.0e-9

class R3
  # проверка на приближённое равенство
  def equal?(other)
    (@x - other.x).abs < DELTA and (@y - other.y).abs < DELTA and
      (@z - other.z).abs < DELTA
  end
end

class Segment
  # проверка на приближённое равенство
  def equal?(other)
    (@beg - other.beg).abs < DELTA and (@end - other.end).abs < DELTA
  end
end

class Edge
  # иначе не протестировать private method 
  def c(a,n); cross(a,n) end
end

class TestEdge < Test::Unit::TestCase
  def test_r3
    s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))

    # Одномерной координате 0.0 соответствует начало ребра
    assert s.beg.equal?(s.r3(0.0))

    # Одномерной координате 1.0 соответствует конец ребра
    assert s.end.equal?(s.r3(1.0))

    # Одномерной координате 0.5 соответствует середина ребра
    assert R3.new(0.5,0.0,-1.0).equal?(s.r3(0.5))
  end

  def test_cross
    # метод cross всегда возвращает одномерный отрезок!

    # ребро принадлежит полупространству, пересечение - весь отрезок
    s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
    a = R3.new(0.0,0.0,0.0)
    n = R3.new(0.0,0.0,1.0)
    assert s.c(a,n).equal?(Segment.new(0.0,1.0))

    # ребро лежит вне полупространства, пересечение пусто
    s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,0.0,1.0))
    a = R3.new(0.0,0.0,0.0)
    n = R3.new(0.0,0.0,1.0)
    assert s.c(a,n).degenerate?

    # ребро принадлежит плоскости, ограничивающей полупространство;
    # так как полупространство является открытым, то пересечение пусто
    s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,0.0,0.0))
    a = R3.new(0.0,0.0,0.0)
    n = R3.new(0.0,0.0,1.0)
    assert s.c(a,n).degenerate?

    # только первая половина отрезка принадлежит полупространству
    s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,1.0))
    a = R3.new(1.0,1.0,0.0)
    n = R3.new(0.0,0.0,1.0)
    assert s.c(a,n).equal?(Segment.new(0.0,0.5))

    # здесь, наоборот, только вторая половина входит в полупространство
    s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,0.0,-1.0))
    a = R3.new(1.0,1.0,0.0)
    n = R3.new(0.0,0.0,1.0)
    assert s.c(a,n).equal?(Segment.new(0.5,1.0))
  end

  def test_shadow
    # грань не затеняет ребро, принадлежащее этой грани
    s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                 R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
    s.shadow(f)
    assert_equal 1, s.gaps.size

    # грань не затеняет ребро, расположенное выше грани
    s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,1.0,1.0))
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                 R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
    s.shadow(f)
    assert_equal 1, s.gaps.size
 
    # грань полностью затеняет ребро, расположенное ниже грани
    s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,1.0,-1.0))
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                 R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
    s.shadow(f)
    assert_equal 0, s.gaps.size
 
    # на большом и длинном ребре, лежащем ниже грани, образуются
    # ровно два просвета
    s = Edge.new(R3.new(-5.0,-5.0,-1.0), R3.new(3.0,3.0,-1.0))
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                 R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
    s.shadow(f)
    assert_equal 2, s.gaps.size
  end
end
