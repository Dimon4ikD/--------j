# encoding: UTF-8
require "test/unit"
require "./convex"
# Вычисляется сумма углов, под которыми рёбра выпуклой оболочки пересекают заданную прямую.

$points = [R2Point.new(0,0), R2Point.new(1,0)]

def test_helper *points
  fig = Void.new
  points.each do |p|
    p = R2Point.new p[0].to_f, p[1].to_f if p.kind_of?(Array) && p.size == 2
    fig.add p
  end
  fig.sum
end

class Figure
  def tst_angle *a
    a.map! { |p| (p.kind_of?(Array) && p.size == 2) ? R2Point.new(p[0].to_f, p[1].to_f) : p }
    angle *a
  end
end

class TestConvex < Test::Unit::TestCase

  EPS = 1.0e-12

  def test_project    
    assert_equal 0.0, test_helper
    assert_equal 0.0, test_helper( [0,0] )
    assert_equal 0.0, test_helper( [1,-1], [1,1], [0,1], [-2,-1] )       
  end
  
  def test_angle
    assert_equal Math::PI/2, Figure.new.tst_angle( [1,0], [0,0], [0,1] )
    assert_equal Math::PI/2, Figure.new.tst_angle( [0,1], [0,0], [1,0] )
    assert_in_delta Math::PI/4, Figure.new.tst_angle( [0,0], [0,1], [1,0] ), EPS
    assert_in_delta Math::PI/4, Figure.new.tst_angle( [1,0], [0,1], [0,0] ), EPS
  end

end  
