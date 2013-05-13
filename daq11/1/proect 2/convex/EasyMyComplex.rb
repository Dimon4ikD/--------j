# encoding: utf-8

class MyComplex
   attr_reader :real, :img

   def initialize(r, i)
      @real = r
      @img = i
   end

   def to_s()	
      return "#{@real} + #{@img}i" if @img >= 0
      "#{@real} - #{@img.abs}i"
   end

   def +(b)
      new_r = @real + b.real
      new_i = @img + b.img
      MyComplex.new(new_r, new_i)
   end

   def -(b)
      new_r = @real - b.real
      new_i = @img - b.img
      MyComplex.new(new_r, new_i)
   end

   # Сопряжённое

   def conjugate()
      new_r = @real
      new_i = -@img
      MyComplex.new(new_r, new_i)
   end

   def *(b)
      new_r = @real * b.real - @img * b.img
      new_i = @img * b.real + @real * b.img
      MyComplex.new(new_r, new_i)
   end

   # 1 / x

   def invert()
      d = (@real * @real + @img * @img).to_f
      new_r = @real / d
      new_i = -@img / d
      MyComplex.new(new_r, new_i)
   end

   def /(b)
      self * b.invert() # число * 1 / b
   end
   
   def fi()
   r = Math.sqrt(@real*@real + @img*@img)
   f = Math.atan2(@real,@img)
   f+=2*Math::PI if f<0
   return r,f
   end
   
   def mollol(r,f)
   @real = Math.cos(f)*r
   @img  = Math.sin(f)*r
   end
end


