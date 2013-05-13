# encoding: UTF-8
require 'test/unit'
require "../shadow/polyedr"

DELTA = 1.0e-9

class Segment
  # проверка на приближённое равенство
  def equal?(other)
    (@beg - other.beg).abs < DELTA and (@end - other.end).abs < DELTA
  end
end

class TestSegment < Test::Unit::TestCase

  def test_degenerate
    # этот отрезок не вырожден
    assert !Segment.new(0.0, 1.0).degenerate?

    # следующие два отрезка являются вырожденными
    assert Segment.new(0.0, -1.0).degenerate?
    assert Segment.new(0.0, 0.0).degenerate?
  end

  def test_intersect
    # пересечение отрезка с самим собой даёт его же
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 1.0)
    assert Segment.new(0.0, 1.0).equal?(a.intersect!(b))

    # пересечение меньшего отрезка с большим даёт меньший
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 2.0)
    assert Segment.new(0.0, 1.0).equal?(a.intersect!(b))

    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 2.0)
    assert Segment.new(0.0, 1.0).equal?(b.intersect!(a))

    # пересечение коммутативно 
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 2.0)
    assert a.intersect!(b).equal?(b.intersect!(a))

    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.5, 1.0)
    assert a.intersect!(b).equal?(b.intersect!(a))

    a = Segment.new(0.0, 1.0)
    b = Segment.new(-0.5, 0.0)
    assert a.intersect!(b).equal?(b.intersect!(a))

    a = Segment.new(0.0, 1.0)
    b = Segment.new(-0.5, -0.1)
    assert a.intersect!(b).equal?(b.intersect!(a))

  end

  def test_subtraction
    # разность двух отрезков всегда массив из двух отрезков!

    # разность отрезка с самим собой - два вырожденных отрезка
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 1.0)
    assert a.subtraction(b).all?{|s| s.degenerate?}

    # для двух отрезков с совпадающим началом
    # вычитание из большего отрезка меньшего порождает
    # один вырожденный и один невырожденный отрезок
    a = Segment.new(0.0, 2.0)
    b = Segment.new(0.0, 1.0)
    assert a.subtraction(b).any?{|s| s.degenerate?}
    assert a.subtraction(b).any?{|s| !s.degenerate?}

    # для двух отрезков с различными концами таких,
    # что один из них содержится внутри другого,
    # вычитание из большего отрезка меньшего порождает
    # два невырожденных отрезка
    a = Segment.new(-1.0, 2.0)
    b = Segment.new(0.0, 1.0)
    assert a.subtraction(b).all?{|s| !s.degenerate?}

    # вычитание из меньшего отрезка большего порождает
    # два вырожденных отрезка
    a = Segment.new(-1.0, 2.0)
    b = Segment.new(0.0, 1.0)
    assert b.subtraction(a).all?{|s| s.degenerate?}

    # если из первого отрезка вычесть второй, а из 
    # получившегося результата затем - третий, то 
    # все получившиеся в конечном итоги отрезки будут вырождены
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 0.5)
    c = Segment.new(0.5, 1.0)
    assert a.subtraction(b).map{|s| s.subtraction(c)}.flatten.all?{|s| s.degenerate?}

    # здесь невырожденным будет только один из итоговых отрезков
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.0, 0.5)
    c = Segment.new(0.6, 1.0)
    assert_equal 1, a.subtraction(b).map{|s| s.subtraction(c)}.flatten.find_all{|s| !s.degenerate?}.size

    # а здесь невырожденных отрезков в итоге будет три
    a = Segment.new(0.0, 1.0)
    b = Segment.new(0.1, 0.2)
    c = Segment.new(0.4, 0.8)
    assert_equal 3, a.subtraction(b).map{|s| s.subtraction(c)}.flatten.find_all{|s| !s.degenerate?}.size
   end
end  
