#!/usr/bin/env ruby
require "./convex"

fig = Void.new
begin
  while true
    fig = fig.add(R2Point.new)
    puts "S = #{fig.area}, P = #{fig.perimeter}, DTL = #{fig.dist_to_line}"
  end
rescue EOFError
  puts "\nStop"
end
