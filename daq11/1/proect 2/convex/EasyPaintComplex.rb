# encoding: utf-8

require 'tk'
require './EasyMyComplex.rb'

class PaintComplex
	attr_reader :number
	attr_writer :number

	def initialize(w, h, z = MyComplex.new(gets.to_i, gets.to_i))
		@w, @h = w - 10, h - 10
		@number = z 

                # Создание окна, холста и декартовых осей
		@root   = TkRoot.new{title 'Complex number'; geometry "#{w}x#{h}"}
		@canvas = TkCanvas.new(@root, 'height' => @w, 'width' => @h)
		@canvas.pack{ padx 5; pady 5 }
		TkcRectangle.new(@canvas, 0, 0, @w, @h, 'width' => 0) { fill('white') }
		TkcLine.new(@canvas, @w / 2, 0, @w / 2, @h) { fill('black') }
		TkcLine.new(@canvas, 0, @h / 2, @w, @h / 2) { fill('black') }
	end

	def draw_number()
		TkcLine.new(@canvas, @w / 2, @h / 2, @w / 2 + @number.real, @h / 2  - @number.img) { fill('blue') }
	end

end

p = PaintComplex.new(400, 400, 
                     MyComplex.new((rand(45) + 50) * (-1)**rand(2), 
                                   (rand(45) + 50) * (-1)**rand(2)))
# Замените две предыдущих строки и запятую на скобку ), чтобы число
# вводилось, а не генерировалось случайно
n=0
step=Math::PI/18
while n!=36
n+=1
p.draw_number()
r,phi=p.number.fi()
phi=phi+step
p.number.mollol(r,phi)
end
Tk.mainloop
