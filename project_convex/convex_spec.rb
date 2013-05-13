require 'rspec'
require "./convex"

EPS = 1.0e-12
$k = 1
$b = 0
describe Void do

  before(:each) do
    @fig = Void.new
  end

  it "Конструктор порождает экземпляр класса Void (нульугольник)" do
    @fig.should be_an_instance_of(Void)
  end

  it "Нульугольник является фигурой" do
    @fig.should be_a_kind_of(Figure)
  end

  it "Периметр нульугольника нулевой" do
    @fig.perimeter.should be_within(EPS).of(0.0)
  end

  it "Площадь нульугольника нулевая" do
    @fig.area.should be_within(EPS).of(0.0)
  end

  it "При добавлении точки нульугольник превращается в одноугольник" do
    @fig.add(R2Point.new(0.0,0.0)).should be_an_instance_of(Point)
  end

end

describe Point do

  before(:each) do
    @fig = Point.new(R2Point.new(0.0,0.0))
  end

  it "Конструктор порождает экземпляр класса Point (одноугольник)" do
    @fig.should be_an_instance_of(Point)
  end

  it "Одноугольник является фигурой" do
    @fig.should be_a_kind_of(Figure)
  end

  it "Периметр одноугольника нулевой" do
    @fig.perimeter.should be_within(EPS).of(0.0)
  end

  it "Площадь одноугольника нулевая" do
    @fig.area.should be_within(EPS).of(0.0)
  end

  it "При добавлении точки одноугольник может не измениться" do
    @fig.add(R2Point.new(0.0,0.0)).should equal(@fig)
  end

  it "При добавлении точки одноугольник может стать двуугольником" do
    @fig.add(R2Point.new(1.0,0.0)).should be_an_instance_of(Segment)
  end

  it "Для данная точка лежит на y =x " do
    @fig.func == 1
  end





end

describe Segment do

  before(:each) do
    @fig = Segment.new(R2Point.new(0.0,0.0), R2Point.new(1.0,0.0))
  end

  it "Конструктор порождает экземпляр класса Segment (двуугольник)" do
    @fig.should be_an_instance_of(Segment)
  end

  it "Двуугольник является фигурой" do
    @fig.should be_a_kind_of(Figure)
  end

  it "Периметр двуугольника равен удвоенной длине отрезка" do
    @fig.perimeter.should be_within(EPS).of(2.0)
  end

  it "Площадь двуугольника нулевая" do
    @fig.area.should be_within(EPS).of(0.0)
  end

  it "При добавлении точки двуугольник может не измениться" do
    @fig.add(R2Point.new(0.5,0.0)).should equal(@fig)
  end

  it "При добавлении точки двуугольник может стать другим двуугольником" do
    fig_new = @fig.add(R2Point.new(1.5,0.0))
    fig_new.should be_an_instance_of(Segment)
    fig_new.perimeter.should be_within(EPS).of(3.0)
  end

  it "При добавлении точки двуугольник может стать треугольником" do
    fig_new = @fig.add(R2Point.new(0.0,1.0))
    fig_new.should be_an_instance_of(Polygon)
    fig_new.perimeter.should be_within(EPS).of(2.0+Math.sqrt(2.0))
    fig_new.area.should be_within(EPS).of(0.5)
  end

  it "Мощность для y =x = 1 " do
    @fig.func == 1
  end

end

describe Polygon do

  before(:each) do
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(0.0,1.0)
    @fig = Polygon.new(a,b,c)
  end

  context "Общие свойства:" do

    it "конструктор порождает экземпляр класса Polygon (многоугольник)" do
      @fig.should be_an_instance_of(Polygon)
    end

    it "многоугольник является фигурой" do
      @fig.should be_a_kind_of(Figure)
    end

  end

  context "Изменение количества вершин многоугольника:" do

    it "изначально их три" do
      @fig.points.size.should == 3
    end

    it "добавление точки внутрь многоугольника не меняет их количества" do
      @fig.add(R2Point.new(0.1,0.1)).points.size.should == 3
    end

    it "Мощность для y =x = infinity " do
      @fig.func == "infinity"
    end


    it "добавление другой точки может изменить их количество" do
      @fig.add(R2Point.new(1.0,1.0)).points.size.should == 4
    end
    it "Мощность для y =x = infinity " do
      @fig.func == "infinity"
    end
    it "изменения выпуклой оболочки могут и уменьшать их количество" do
      @fig.add(R2Point.new(0.4,1.0)).points.size.should == 4
      @fig.add(R2Point.new(1.0,0.4)).points.size.should == 5
      @fig.add(R2Point.new(0.8,0.9)).points.size.should == 6
      @fig.add(R2Point.new(0.9,0.8)).points.size.should == 7
      @fig.add(R2Point.new(2.0,2.0)).points.size.should == 4
    end

  end

  context "Изменение периметра многоугольника:" do

    it "изначально он равен сумме длин сторон" do
      @fig.perimeter.should be_within(EPS).of(2.0+Math.sqrt(2.0))
    end

    it "добавление точки может его изменить" do
      @fig.add(R2Point.new(1.0,1.0)).perimeter.should be_within(EPS).of(4.0)
    end

    it "изменения выпуклой оболочки могут значительно его увеличить" do
      @fig.add(R2Point.new(0.4,1.0))
      @fig.add(R2Point.new(1.0,0.4))
      @fig.add(R2Point.new(0.8,0.9))
      @fig.add(R2Point.new(0.9,0.8))
      @fig.add(R2Point.new(2.0,2.0))
      @fig.add(R2Point.new(0.0,2.0))
      @fig.add(R2Point.new(2.0,0.0)).perimeter.should be_within(EPS).of(8.0)
    end

  end

  context "Изменение площади многоугольника:" do

    it "изначально она равна (неориентированной) площади треугольника" do
      @fig.area.should be_within(EPS).of(0.5)
    end

    it "добавление точки может её изменить" do
      @fig.add(R2Point.new(1.0,1.0)).area.should be_within(EPS).of(1.0)
    end

    it "изменения выпуклой оболочки могут значительно её увеличить" do
      @fig.add(R2Point.new(0.4,1.0))
      @fig.add(R2Point.new(1.0,0.4))
      @fig.add(R2Point.new(0.8,0.9))
      @fig.add(R2Point.new(0.9,0.8))
      @fig.add(R2Point.new(2.0,2.0))
      @fig.add(R2Point.new(0.0,2.0))
      @fig.add(R2Point.new(2.0,0.0)).area.should be_within(EPS).of(4.0)
    end

  end

end
