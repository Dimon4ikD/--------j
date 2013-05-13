require 'rspec'
require '../shadow/polyedr'

EPS = 1.0e-12

class R3
  # проверка на приближённое равенство
  def equal?(other)
    (@x - other.x).abs < EPS and (@y - other.y).abs < EPS and
      (@z - other.z).abs < EPS
  end
end

class Segment
  # проверка на приближённое равенство
  def equal?(other)
    (@beg - other.beg).abs < EPS and (@fin - other.fin).abs < EPS
  end
end

class Edge
  # метод для обеспечения вызова private метода cross
  def c(a,n); cross(a,n) end
end

describe Edge do

  context "r3" do

    it "одномерной координате 0.0 соответствует начало ребра" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      s.beg.equal?(s.r3(0.0)).should be_true
    end
    
    it "одномерной координате 1.0 соответствует конец ребра" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      s.fin.equal?(s.r3(1.0)).should be_true
    end
    
    it "одномерной координате 0.5 соответствует середина ребра" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      R3.new(0.5,0.0,-1.0).equal?(s.r3(0.5)).should be_true
    end
    
  end

  context "cross" do
    # метод cross всегда возвращает одномерный отрезок!

    it "если ребро принадлежит полупространству, то пересечение - весь отрезок" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      a = R3.new(0.0,0.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      s.c(a,n).equal?(Segment.new(0.0,1.0)).should be_true
    end

    it "если ребро лежит вне полупространства, то пересечение пусто" do
      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,0.0,1.0))
      a = R3.new(0.0,0.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      s.c(a,n).degenerate?.should be_true
    end

    it "если ребро принадлежит плоскости, ограничивающей полупространство, то пересечение пусто" do
      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,0.0,0.0))
      a = R3.new(0.0,0.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      s.c(a,n).degenerate?.should be_true
    end

    it "здесь только первая половина отрезка принадлежит полупространству" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,1.0))
      a = R3.new(1.0,1.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      s.c(a,n).equal?(Segment.new(0.0,0.5)).should be_true
    end

    it "здесь только вторая половина отрезка принадлежит полупространству" do
      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,0.0,-1.0))
      a = R3.new(1.0,1.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      s.c(a,n).equal?(Segment.new(0.5,1.0)).should be_true
    end

  end

  context "shadow" do

    it "грань не затеняет ребра, принадлежащего этой же грани" do
      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      s.gaps.size.should == 1
    end

    it "грань не затеняет ребра, расположенного выше грани" do
      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,1.0,1.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      s.gaps.size.should == 1
    end

    it "грань полностью затеняет ребро, расположенное ниже грани" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,1.0,-1.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      s.gaps.size.should == 0
    end

    it "на большом и длинном ребре, лежащем ниже грани, образуется ровно два просвета" do
      s = Edge.new(R3.new(-5.0,-5.0,-1.0), R3.new(3.0,3.0,-1.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      s.gaps.size.should == 2
    end

  end
end
