# encoding: UTF-8
require 'test/unit'
require './r2point'

class TestR2Point < Test::Unit::TestCase

  EPS = 1.0e-12

  def test_area
    a = R2Point.new(0.0,0.0)
    assert_in_delta 0.0, R2Point.area(a,a,a), EPS
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(2.0,0.0)
    assert_in_delta 0.0, R2Point.area(a,b,c), EPS
    b = R2Point.new(1.0,-1.0)
    assert_in_delta 1.0, R2Point.area(a,b,c), EPS
    b = R2Point.new(1.0,1.0)
    assert_in_delta -1.0, R2Point.area(a,b,c), EPS
  end

  def test_dist
    a = R2Point.new(1.0,1.0)
    assert_in_delta 0.0, a.dist(R2Point.new(1.0,1.0)), EPS
    assert_in_delta 1.0, a.dist(R2Point.new(1.0,0.0)), EPS
    assert_in_delta Math.sqrt(2.0), a.dist(R2Point.new(0.0,0.0)), EPS
  end

  def test_inside?
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(2.0,1.0)
    assert R2Point.new(1.0,0.5).inside?(a,b)
    assert R2Point.new(1.0,0.5).inside?(b,a)
    assert !R2Point.new(1.0,1.5).inside?(a,b)
    assert !R2Point.new(1.0,1.5).inside?(b,a)
  end

  def test_light?
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    assert !R2Point.new(0.5,0.0).light?(a,b)
    assert R2Point.new(0.5,-0.5).light?(a,b)
    assert R2Point.new(2.0,0.0).light?(a,b)
    assert !R2Point.new(0.5,0.5).light?(a,b)
    assert R2Point.new(-1.0,0.0).light?(a,b)
  end

end  
