#!/usr/bin/env ruby
require "./convex"

fig = Void.new
begin
  puts "Вводим параметры прямой"
  print "Введите k -->"
  $k = gets.to_i
  print "Введите b -->"
  $b = gets.to_i
  while true
    fig = fig.add(R2Point.new)
    puts "S = #{fig.area}, P = #{fig.perimeter}, s = #{fig.func}"
  end
rescue EOFError
  puts "\nStop"
end
