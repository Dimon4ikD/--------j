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

 context "lies_on1:" do

    before(:each) do
      @k = 1
      @b = 0

    it "(1,1) лежит на y = x" do
      R2Point.new(1,1).lies_on?(@k,@b).should be_true
    end

    it "(-1,-1) лежит на y = x" do
      R2Point.new(-1,-1).lies_on?(@k,@b).should be_true
    end

    it "(0,0) лежит на y = x" do
      R2Point.new(0,0).lies_on?(@k,@b).should be_true
    end

    it "(-1,1) не лежит на y = x" do
      R2Point.new(-1,1).lies_on?(@k,@b).should be_false
    end

    it "(-1,2) не лежит на y = x" do
      R2Point.new(-1,2).lies_on?(@k,@b).should be_false
    end

  end

 context "lies_on:" do

    before(:each) do
      @k = 1
      @b = 0

    it "(1,1), (0,0) лежит на y = x" do
      R2Point.lies_on?(@k,@b, R2Point.new(1,1), R2Point.new(0,0)).should be_true
    end

    it "(1,1), (10,0) не лежит на y = x" do
      R2Point.lies_on?(@k,@b, R2Point.new(1,1), R2Point.new(10,0)).should be_false
    end

  end

 context "crossing_line:" do

    before(:each) do
      @k = 1
      @b = 0

    it "(1,1), (0,0) не пересекает y = x" do
      R2Point.crossing_line?(@k,@b, R2Point.new(1,1), R2Point.new(0,0)).should be_false
    end

    it "(1,1), (10,0) пересекает на y = x" do
      R2Point.crossing_line?(@k,@b, R2Point.new(1,1), R2Point.new(10,0)).should be_true
    end
	  it "(2,0), (-2,0) пересекает на y = x" do
      R2Point.crossing_line?(@k,@b, R2Point.new(2,0), R2Point.new(-2,0)).should be_true
    end
  end

end  
