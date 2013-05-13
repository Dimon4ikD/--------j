# encoding: UTF-8
require "test/unit"
require "./convex"

class TestConvex < Test::Unit::TestCase

  EPS = 1.0e-12

  def test_void
    fig = Void.new
    assert_instance_of Void, fig
    assert_in_delta 0.0, fig.perimeter, EPS
    assert_in_delta 0.0, fig.area, EPS
    assert_instance_of Point, fig.add(R2Point.new(0.0,0.0))
  end

  def test_point
    fig = Point.new(R2Point.new(0.0,0.0))
    assert_instance_of Point, fig
    assert_in_delta 0.0, fig.perimeter, EPS
    assert_in_delta 0.0, fig.area, EPS
    assert_instance_of Point, fig.add(R2Point.new(0.0,0.0))
    assert_instance_of Segment, fig.add(R2Point.new(1.0,0.0))
  end

  def test_segment
    fig = Segment.new(R2Point.new(0.0,0.0), R2Point.new(1.0,0.0))
    assert_instance_of Segment, fig
    assert_in_delta 2.0, fig.perimeter, EPS
    assert_in_delta 0.0, fig.area, EPS
    
    fig_new = fig.add(R2Point.new(0.5,0.0))
    assert_same fig, fig_new
    assert_in_delta 2.0, fig_new.perimeter, EPS
    assert_in_delta 0.0, fig_new.area, EPS
    
    fig_new = fig.add(R2Point.new(1.5,0.0))
    assert_not_same fig, fig_new
    assert_instance_of Segment, fig_new
    assert_in_delta 3.0, fig_new.perimeter, EPS
    assert_in_delta 0.0, fig_new.area, EPS

    fig_new = fig.add(R2Point.new(0.0,1.0))
    assert_instance_of Polygon, fig_new
    assert_in_delta 2.0+Math.sqrt(2.0), fig_new.perimeter, EPS
    assert_in_delta 0.5, fig_new.area, EPS
  end

  def test_polygon_1
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(0.0,1.0)
    fig = Polygon.new(a,b,c)
    assert_in_delta 2.0+Math.sqrt(2.0), fig.perimeter, EPS
    assert_in_delta 0.5, fig.area, EPS

    fig_old = fig.clone
    fig.add(R2Point.new(0.1,0.1))
    assert_equal fig_old.points, fig.points
    assert_equal fig_old.perimeter, fig.perimeter
    assert_equal fig_old.area, fig.area

    fig_old = fig.clone
    fig.add(R2Point.new(1.0,1.0))
    assert_equal fig_old.points, fig.points
    assert_in_delta 4.0, fig.perimeter, EPS
    assert_in_delta 1.0, fig.area, EPS
  end

  def test_polygon_2
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(0.0,1.0)
    fig = Polygon.new(a,b,c)
    fig.add(R2Point.new(1.0,1.0))
    fig.add(R2Point.new(2.0,2.0))
    fig.add(R2Point.new(0.0,2.0))
    fig.add(R2Point.new(2.0,0.0))
    assert_in_delta 8.0, fig.perimeter, EPS
    assert_in_delta 4.0, fig.area, EPS
  end
 
  def test_polygon_3
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(0.0,1.0)
    fig = Polygon.new(a,b,c)
    fig.add(R2Point.new(0.4,1.0))
    fig.add(R2Point.new(1.0,0.4))
    fig.add(R2Point.new(0.8,0.9))
    fig.add(R2Point.new(0.9,0.8))
    assert_equal 7, fig.points.size
    fig.add(R2Point.new(2.0,2.0))
    assert_equal 4, fig.points.size
    fig.add(R2Point.new(0.0,2.0))
    fig.add(R2Point.new(2.0,0.0))
    assert_in_delta 8.0, fig.perimeter, EPS
    assert_in_delta 4.0, fig.area, EPS
   end
end  
