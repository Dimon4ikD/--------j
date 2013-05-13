require 'rspec'
require "./convex"

EPS = 1.0e-12

describe Point do

  it "Расстояние от точки M(0,0), лежащей ниже прямой y-x-1=0 равно " do
    @fig = Point.new(R2Point.new(0.0,0.0),1,-1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.7071067811865475)
  end

  it "Расстояние от точки M(0,1), лежащей на наклонной прямой y-x-1=0 равно " do
    @fig = Point.new(R2Point.new(0.0,1.0),1,-1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от точки M(1,4), лежащей выше наклонной прямой y-x-1=0 равно " do
    @fig = Point.new(R2Point.new(1.0,4.0),1,-1,-1)
    @fig.dist_to_line.should be_within(EPS).of(1.414213562373095)
  end

  it "Расстояние от точки M(0,0), лежащей ниже прямой y=1 равно " do
    @fig = Point.new(R2Point.new(0.0,0.0),1,0,-1)
    @fig.dist_to_line.should be_within(EPS).of(1.0)
  end

  it "Расстояние от точки M(0,1), лежащей на прямой y=1 равно " do
    @fig = Point.new(R2Point.new(0.0,1.0),1,0,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от точки M(1,4), лежащей выше прямой y=1 равно " do
    @fig = Point.new(R2Point.new(1.0,4.0),1,0,-1)
    @fig.dist_to_line.should be_within(EPS).of(3.0)
  end

  it "Расстояние от точки M(0,0), лежащей левее прямой x=1 равно " do
    @fig = Point.new(R2Point.new(0.0,0.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(1.0)
  end

  it "Расстояние от точки M(3,1), лежащей правее наклонной прямой x=1 равно " do
    @fig = Point.new(R2Point.new(3.0,1.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(2.0)
  end

  it "Расстояние от точки M(1,4), лежащей на наклонной прямой x=1 равно " do
    @fig = Point.new(R2Point.new(1.0,4.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

end

describe Segment do

  it "Расстояние от отрезка M(0,0) N(1,0) до прямой y-x-1=0" do
    @fig = Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),1,-1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.7071067811865475)
  end

  it "Расстояние от отрезка M(2,1) N(1,4) до прямой y-x-1=0" do
    @fig = Segment.new(R2Point.new(2.0,1.0),R2Point.new(1.0,4.0),1,-1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от отрезка M(3,0) N(2,2) до прямой y-x-1=0" do
    @fig = Segment.new(R2Point.new(3.0,0.0),R2Point.new(2.0,2.0),1,-1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.7071067811865475)
  end

  it "Расстояние от отрезка M(0,0) N(1,0) до прямой y=1" do
    @fig = Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),1,0,-1)
    @fig.dist_to_line.should be_within(EPS).of(1.0)
  end

  it "Расстояние от отрезка M(2,1) N(1,4) до прямой y=1" do
    @fig = Segment.new(R2Point.new(2.0,1.0),R2Point.new(1.0,4.0),1,0,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от отрезка M(3,0) N(2,2) до прямой y=1" do
    @fig = Segment.new(R2Point.new(3.0,0.0),R2Point.new(2.0,2.0),1,0,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от отрезка M(0,0) N(1,0) до прямой x=1" do
    @fig = Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от отрезка M(2,1) N(1.3,4) до прямой x=1" do
    @fig = Segment.new(R2Point.new(2.0,1.0),R2Point.new(1.3,4.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.3)
  end

  it "Расстояние от отрезка M(3,0) N(2,2) до прямой x=1" do
    @fig = Segment.new(R2Point.new(3.0,0.0),R2Point.new(2.0,2.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(1.0)
  end

  it "Расстояние от отрезка M(0,0) N(1,0) до прямой x=1" do
    @fig = Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от отрезка M(2,1) N(1.3,4) до прямой x=1" do
    @fig = Segment.new(R2Point.new(2.0,1.0),R2Point.new(1.3,4.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(0.3)
  end

  it "Расстояние от отрезка M(3,0) N(2,2) до прямой x=1" do
    @fig = Segment.new(R2Point.new(3.0,0.0),R2Point.new(2.0,2.0),0,1,-1)
    @fig.dist_to_line.should be_within(EPS).of(1.0)
  end


end

describe Polygon do

  it "Расстояние от многоугольника A(0,0) B(1,1) C(1.5,1.4) до прямой y-x-1=0" do
    @fig = Polygon.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(1.5,1.4),1,-1,-1,2)
    @fig.dist_to_line.should be_within(EPS).of(0.7071067811865475)
  end

  it "Расстояние от многоугольника A(0,0) B(1,1) C(1.5,1.4) с добавленной точкой D(1,2) до прямой y-x-1=0" do
    @fig = Polygon.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(1.5,1.4),1,-1,-1,2)
    @fig.add(R2Point.new(1.0,2.0))
    @fig.dist_to_line.should be_within(EPS).of(0.0)
  end

  it "Расстояние от многоугольника A(1.6,4.4) B(1.8,4.0) C(1,4) до прямой y-x-1=0" do
    @fig = Polygon.new(R2Point.new(1.6,4.4),R2Point.new(1.8,4.0),R2Point.new(1.0,4.0),1,-1,-1,2)
    @fig.dist_to_line.should be_within(EPS).of(0.8485281374238571)
  end

end
