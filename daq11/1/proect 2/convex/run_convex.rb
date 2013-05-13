#!/usr/bin/env ruby
# encoding: UTF-8
require "./convex"

fig = Void.new
begin
  while true
    fig = fig.add(R2Point.new)
    puts "S = #{fig.area}, P = #{fig.perimeter}, Sin = #{fig.sins}, Sumx = #{fig.sumx}"
  end
rescue EOFError
  puts "\nStop"
end
