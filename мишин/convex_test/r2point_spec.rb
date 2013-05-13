require 'rspec'
require './r2point'

describe R2Point do

  EPS = 1.0e-12

  context "Расстояние dist" do

    it "от точки до самой себя равно нулю" do
      a = R2Point.new(1.0,1.0)
      a.dist(R2Point.new(1.0,1.0)).should be_within(EPS).of(0.0) 
    end

    it "от одной точки до отличной от неё другой положительно" do
      a = R2Point.new(1.0,1.0)
      a.dist(R2Point.new(1.0,0.0)).should be_within(EPS).of(1.0) 
      a.dist(R2Point.new(0.0,0.0)).should be_within(EPS).of(Math.sqrt(2.0)) 
    end

  end

  context "Площадь area" do

    before(:each) do
      @a = R2Point.new(0.0,0.0)
      @b = R2Point.new(1.0,-1.0)
      @c = R2Point.new(2.0,0.0)
    end

    it "равна нулю, если все вершины совпадают" do
      R2Point.area(@a,@a,@a).should be_within(EPS).of(0.0)
    end

    it "равна нулю, если вершины лежат на одной прямой" do
      @b = R2Point.new(1.0,0.0)
      R2Point.area(@a,@b,@c).should be_within(EPS).of(0.0)
    end

    it "положительна, если обход вершин происходит против часовой стрелки" do
      R2Point.area(@a,@b,@c).should be_within(EPS).of(1.0)
    end

    it "отрицательна, если обход вершин происходит по часовой стрелки" do
      R2Point.area(@a,@c,@b).should be_within(EPS).of(-1.0)
    end

  end

  context "inside? для прямоугольника с вершинами (0,0) и (2,1) утверждает:" do

    before(:each) do
      @a = R2Point.new(0.0,0.0)
      @b = R2Point.new(2.0,1.0)
    end

    it "точка (1,0.5) внутри" do
      R2Point.new(1.0,0.5).inside?(@a,@b).should be_true
    end

    it "точка (1,0.5) внутри" do
      R2Point.new(1.0,0.5).inside?(@b,@a).should be_true
    end

    it "точка (1,1.5) снаружи" do
      R2Point.new(1.0,1.5).inside?(@a,@b).should be_false
    end

    it "точка (1,1.5) снаружи" do
      R2Point.new(1.0,1.5).inside?(@b,@a).should be_false
    end

  end

  context "light? для ребра с вершинами (0,0) и (1,0) утверждает:" do

    before(:each) do
      @a = R2Point.new(0.0,0.0)
      @b = R2Point.new(1.0,0.0)
    end

    it "из точки (0.5,0.0) оно не освещено" do
      R2Point.new(0.5,0.0).light?(@a,@b).should be_false
    end

    it "из точки (0.5,-0.5) оно освещено" do
      R2Point.new(0.5,-0.5).light?(@a,@b).should be_true
    end

    it "из точки (2.0,0.0) оно освещено" do
      R2Point.new(2.0,0.0).light?(@a,@b).should be_true
    end

    it "из точки (0.5,0.5) оно не освещено" do
      R2Point.new(0.5,0.5).light?(@a,@b).should be_false
    end

    it "из точки (-1.0,0.0) оно освещено" do
      R2Point.new(-1.0,0.0).light?(@a,@b).should be_true
    end

  end

  context "Тестирование медота distline" do

    it "Расстояние от точки лежащей на наклонной прямой должно быть равно 0" do
      a=1.0
      b=-1.0
      c=-1.0
      R2Point.new(1.0,2.0).distline(a,b,c).should be_within(EPS).of(0.0)
    end

    it "Расстояние от точки лежащей на горизонтальной прямой должно быть равно 0" do
      a=1.0
      b=0.0
      c=-1.0
      R2Point.new(0.0,1.0).distline(a,b,c).should be_within(EPS).of(0.0)
    end

    it "Расстояние от точки лежащей на вертикальной прямой должно быть равно 0" do
      a=0.0
      b=1.0
      c=-1.0
      R2Point.new(1.0,-3.0).distline(a,b,c).should be_within(EPS).of(0.0)
    end

    it "Расстояние от точки M(1,1) до прямой x-y-1=0" do
      a=1.0
      b=-1.0
      c=-1.0
      R2Point.new(1.0,1.0).distline(a,b,c).should be_within(EPS).of(0.7071067811865475)
    end

    it "Расстояние от точки M(-1.3,2.7) до прямой x=2.4" do
      a=0.0
      b=1.0
      c=-2.4
      R2Point.new(-1.3,2.7).distline(a,b,c).should be_within(EPS).of(3.7)
    end

    it "Расстояние от точки M(-0.1,-3,5) до прямой y=-3.4" do
      a=1.0
      b=0.0
      c=3.4
      R2Point.new(-0.1,-3.5).distline(a,b,c).should be_within(EPS).of(0.10000000000000009)
    end

  end

end  
