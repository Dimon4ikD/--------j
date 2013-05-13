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

  # квадрат длины векторного произведения с заданным вектором
  def sq_len(other)
    w = v(other)
    w.x*w.x + w.y*w.y + w.z*w.z
  end
end

class Facet
  # иначе не протестировать private method 
  def c; center end
end

class TestFacet < Test::Unit::TestCase
  def test_vertical
    # эта грань не является вертикальной
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                 R3.new(0.0,3.0,0.0)])
    assert !f.vertical?

    # а эта грань - вертикальна
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(0.0,0.0,1.0),
                 R3.new(1.0,0.0,0.0)])
    assert f.vertical?
  end

  def test_h_normal
    # нормаль к такой грани направлена вертикально вверх
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                 R3.new(0.0,3.0,0.0)])
    assert_in_delta 0.0, f.h_normal.sq_len(R3.new(0.0,0.0,1.0)), DELTA

    # а к этой - вертикально вниз
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(0.0,3.0,0.0),
                 R3.new(3.0,0.0,0.0)])
    assert_in_delta 0.0, f.h_normal.sq_len(R3.new(0.0,0.0,-1.0)), DELTA

    # здесь нормаль иная (нарисуйте картинку!)
    f=Facet.new([R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0),
                 R3.new(0.0,0.0,1.0)])
    assert_in_delta 0.0, f.h_normal.sq_len(R3.new(1.0,1.0,1.0)), DELTA
  end

  def test_v_normals
    # для каждой из следующих граней сначала "вручную" находятся
    # внешние нормали к вертикальным плоскостям, проходящим через
    # рёбра заданной грани, а затем проверяется, что эти нормали
    # имеют то же направление, что и вычисляемые методом v_normals

    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),R3.new(0.0,3.0,0.0)])
    normals = [R3.new(-1.0,0.0,0.0), R3.new(0.0,-1.0,0.0),R3.new(1.0,1.0,0.0)]
    f.v_normals.zip(normals) do |arr|
      assert_in_delta 0.0, arr[0].sq_len(arr[1]), DELTA
    end

    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                 R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
    normals = [R3.new(-1.0,0.0,0.0),R3.new(0.0,-1.0,0.0),
               R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0)]
    f.v_normals.zip(normals) do |arr|
      assert_in_delta 0.0, arr[0].sq_len(arr[1]), DELTA
    end
   
    f=Facet.new([R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0),
                 R3.new(0.0,0.0,1.0)])
    normals = [R3.new(0.0,-1.0,0.0), R3.new(1.0,1.0,0.0),R3.new(-1.0,0.0,0.0)]
    f.v_normals.zip(normals) do |arr|
      assert_in_delta 0.0, arr[0].sq_len(arr[1]), DELTA
    end
  end

  def test_center
    # центр квадрата
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                 R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
    assert R3.new(1.0,1.0,0.0).equal?(f.c)

    # центр треугольника
    f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                 R3.new(0.0,3.0,0.0)])
    assert R3.new(1.0,1.0,0.0).equal?(f.c)
  end
end
