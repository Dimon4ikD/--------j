require 'rspec'
require '../shadow/polyedr'

EPS = 1.0e-6

class R3

  # проверка на приближённое равенство
  def equal?(other)
    (@x - other.x).abs < EPS and (@y - other.y).abs < EPS and
      (@z - other.z).abs < EPS
  end

  # угол между векторами
  def angle(other)
    t = s(other)/Math.sqrt(x*x+y*y+z*z)/
              Math.sqrt(other.x**2+other.y**2+other.z**2)
    begin
      Math.acos(t)
    rescue DomainError
      t = -1.0 if t < -1.0
      t =  1.0 if t >  1.0
      Math.acos(t)
    end
  end

end

class Facet
  # метод для обеспечения вызова private метода center
  def c; center end
end

describe Facet do

  context "vertical" do

    it "эта грань не является вертикальной" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
      f.vertical?.should be_false
    end
    
    it "эта грань вертикальна" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(0.0,0.0,1.0),
                   R3.new(1.0,0.0,0.0)])
      f.vertical?.should be_true
    end

  end

  context "h_normal" do

    it "нормаль к этой грани направлена вертикально вверх" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
      f.h_normal.angle(R3.new(0.0,0.0,1.0)).should be_within(EPS).of(0.0)
    end

    it "нормаль к этой грани тоже направлена вертикально вверх!" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(0.0,3.0,0.0),
                   R3.new(3.0,0.0,0.0)])
      f.h_normal.angle(R3.new(0.0,0.0,1.0)).should be_within(EPS).of(0.0)
    end

    it "для нахождения нормали к этой грани рекомендуется нарисовать картинку" do
      f=Facet.new([R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0),
                   R3.new(0.0,0.0,1.0)])
      f.h_normal.angle(R3.new(1.0,1.0,1.0)).should be_within(EPS).of(0.0)
    end

  end

  context "v_normals" do
    # для каждой из следующих граней сначала "вручную" находятся
    # внешние нормали к вертикальным плоскостям, проходящим через
    # рёбра заданной грани, а затем проверяется, что эти нормали
    # имеют то же направление, что и вычисляемые методом v_normals

    it "нормали для треугольной грани" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),R3.new(0.0,3.0,0.0)])
      normals = [R3.new(-1.0,0.0,0.0), R3.new(0.0,-1.0,0.0),R3.new(1.0,1.0,0.0)]
      f.v_normals.zip(normals) do |arr|
        arr[0].angle(arr[1]).should be_within(EPS).of(0.0)
      end
    end

    it "нормали для квадратной грани" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      normals = [R3.new(-1.0,0.0,0.0),R3.new(0.0,-1.0,0.0),
                 R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0)]
      f.v_normals.zip(normals) do |arr|
        arr[0].angle(arr[1]).should be_within(EPS).of(0.0)
      end
    end

    it "нормали для ещё одной треугольной грани" do
      f=Facet.new([R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0),
                   R3.new(0.0,0.0,1.0)])
      normals = [R3.new(0.0,-1.0,0.0), R3.new(1.0,1.0,0.0),R3.new(-1.0,0.0,0.0)]
      f.v_normals.zip(normals) do |arr|
        arr[0].angle(arr[1]).should be_within(EPS).of(0.0)
      end
    end

  end

  context "center" do

    it "центр квадрата" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      R3.new(1.0,1.0,0.0).equal?(f.c).should be_true
    end

    it "центр треугольника" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
      R3.new(1.0,1.0,0.0).equal?(f.c).should be_true
    end

  end
end
