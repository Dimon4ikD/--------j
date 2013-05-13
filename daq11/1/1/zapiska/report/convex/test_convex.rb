# encoding: UTF-8
require "test/unit"
require "./convex"

$points = [R2Point.new(0,0), R2Point.new(1,0)]



class Figure
  def tst_angle(*a)
    a.map! { |p| (p.kind_of?(Array) && p.size == 2) ? R2Point.new(p[0].to_f, p[1].to_f) : p }
    angle *a
  end
end

class TestConvex < Test::Unit::TestCase

  EPS = 1.0e-12

  def test_void
    fig = Void.new
    assert_instance_of(Void,fig)
    assert_equal(0.0, fig.sum)
    assert_instance_of(Point,fig.add(R2Point.new(0.0,0.0)))
  end

  def test_point
    fig = Point.new(R2Point.new(0.0,0.0))
    assert_instance_of(Point,fig)
    assert_equal(0.0, fig.sum)
    assert_instance_of(Point,fig.add(R2Point.new(0.0,0.0)))
    assert_instance_of(Segment,fig.add(R2Point.new(1.0,0.0)))
  end

  def test_segment
    fig = Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0))
    assert_instance_of(Segment,fig)
	assert_equal(0.0, fig.sum)
    
    fig_new = fig.add(R2Point.new(0.5,0.0))
    assert_same(fig,fig_new)
	assert_equal(0.0, fig_new.sum)
    
    fig_new = fig.add(R2Point.new(1.5,0.0))
    assert_not_same(fig,fig_new)
    assert_instance_of(Segment,fig_new)
	assert_equal(0.0, fig_new.sum)

    fig_new = fig.add(R2Point.new(0.0,1.5))
    assert_instance_of(Polygon,fig_new)
	assert_in_delta(2.5535900500422257, fig_new.sum)
  end
  
  def test_angle
    assert_equal Math::PI/2, Figure.new.tst_angle( [1,0], [0,0], [0,1] )
    assert_equal Math::PI/2, Figure.new.tst_angle( [0,1], [0,0], [1,0] )
    assert_in_delta Math::PI/4, Figure.new.tst_angle( [0,0], [0,1], [1,0] ), EPS
    assert_in_delta Math::PI/4, Figure.new.tst_angle( [1,0], [0,1], [0,0] ), EPS
  end
 
 
 
  def test_cross_point
    fig = Figure.new
    
    assert_equal false, fig.instance_eval { cross_point(R2Point.new(0.0, 0.0), R2Point.new(0.0, 1.0), R2Point.new(1.0, 0.0), R2Point.new(1.0, 1.0)) }
    assert_equal R2Point.new(0.0, 0.0), fig.instance_eval { cross_point(R2Point.new(0.0, 0.0), R2Point.new(0.0, 1.0), R2Point.new(0.0, 0.0), R2Point.new(1.0, 0.0)) }
  
  end
  	
  def test_equation_from_segment
    fig = Figure.new
    
    result = fig.instance_eval { equation_from_segment(R2Point.new(0.0, 0.0), R2Point.new(0.0, 1.0)) }
    assert_equal -1.0, result[0]
    assert_equal 0.0, result[1]
    assert_equal 0.0, result[2]
  end
end  
