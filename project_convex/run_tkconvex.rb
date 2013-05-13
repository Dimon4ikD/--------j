#!/usr/bin/env ruby
require "./convex"
require "./tk_drawer"

TkDrawer.create
fig = Void.new
fig.draw
begin
  puts "Вводим параметры прямой"
  print "Введите a -->"
  $a = gets.to_i #Угловой коэффициент
  print "Введите b -->"
  $b = gets.to_i #Свободный член
  print "Введите b -->"
  $c = gets.to_i
  c = R2Point.new(10, -1*($b/$a)*10-$c/$a) #Первая точка прямой
  v = R2Point.new(-10, ($b/$a)*10-$c/$a) #Вторая точка прямой
  while true
    fig = fig.add(R2Point.new)
    fig.draw
    TkDrawer.draw_line(c, v, "gold") #Рисуем прямую
    puts "S = #{fig.area}, P = #{fig.perimeter}, s = #{fig.func}"
  end
rescue EOFError
  puts "\nStop"
  sleep 5
end
