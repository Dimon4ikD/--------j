#!/usr/bin/env ruby
# encoding: UTF-8
# Вычисляется сумма углов, под которыми рёбра выпуклой оболочки пересекают заданную прямую.
require "./convex"

$points = [(puts "Input A:"; R2Point.new), (puts "Input B:"; R2Point.new)]
puts "Let's go!\n"

fig = Void.new
while true
  fig = fig.add(R2Point.new)
  puts "Sum = #{(fig.sum*180/Math::PI)}"
end
