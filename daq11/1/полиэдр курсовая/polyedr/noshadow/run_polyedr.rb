#!/usr/bin/env ruby
# encoding: UTF-8
require './polyedr'
require '../common/tk_drawer'
TkDrawer.create
%w(ccc cube box king cow).each do |name|
  puts "============================================================="
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  polyedr = Polyedr.new("../data/#{name}.geom")
  polyedr.draw
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  puts "Площадь хороших полигонов #{polyedr.good_area}."
  print 'Hit "Return" to continue -> '
  $stdout.flush
  gets
end
