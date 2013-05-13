# encoding: UTF-8
require "test/unit"
require "./convex"

$points = [R2Point.new(0,0), R2Point.new(1,0)]

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

    fig_new = fig.add(R2Point.new(0.0,1.0))
    assert_instance_of(Polygon,fig_new)
	assert_in_delta(Math::PI/2+ Math.atan(1/1.5), fig_new.sum)
  end


end  
