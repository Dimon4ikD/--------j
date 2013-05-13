#!/usr/bin/env ruby
# encoding: UTF-8
require "./convex"
require "./tk_drawer"

TkDrawer.create

class Figure
  def draw
    TkDrawer.clean
    TkDrawer.draw_line($points[0], $points[1], "green")
  end
end
class Point < Figure
  def draw
    super
    TkDrawer.draw_point(@p)
  end
end
class Segment < Figure
  def draw
    super
    TkDrawer.draw_line(@p,@q)
  end
end
class Polygon < Figure
  def draw
    super
    TkDrawer.draw_lines(points)
  end
end
class R2Point 
  private
  def input(prompt)
    print("#{prompt} -> "); STDOUT.flush
    readline.to_f
  end
end

$points = [(puts "Input A:"; R2Point.new), (puts "Input B:"; R2Point.new)]
puts "Let's go!\n"

fig = Void.new
fig.draw
begin 
  while true
    fig = fig.add R2Point.new
    puts "Sum = #{(fig.sum*180/Math::PI).round(6)}"
    fig.draw
    sleep 0.5
  end
rescue EOFError
  puts "\nРабота завершена"
  sleep 50
end
