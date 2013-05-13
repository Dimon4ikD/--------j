# encoding: UTF-8
require "../common/polyedr"

class R3
  def length#
    Math.sqrt(@x*@x + @y*@y + @z*@z)#
  end

  def good?#вершина хорошая, если она лежит вне сферы 
    @x*@x + @y*@y + @z*@z > 1#
  end
end

class Facet
  def area#метод, вычисляющий площадь грани
    result = 0.0#

    for i in 1 ... (vertexes.size - 1)#цикл от первой вершины до последней 
      result += triangle_area(vertexes[0], vertexes[i], vertexes[i + 1])
    end

    return 0.5*result#деление результата на 2
  end 

  def good?#метод вершин хороших
    vertexes.each do |vertex|#если вершины хорошие, то  
      return false if !vertex.good?#вернем false если вершина не хорошая
    end

    return true#вернем правду
  end

  private

  def triangle_area(a, b, c)#площать треугольников рассматривать 
    ((b - a).v(c - a)).length#модуль векторов length-модуль
  end
end

class Polyedr 
  def draw
    TkDrawer.clean
    edges.each{|e| TkDrawer.draw_line(e.beg, e.end)}
  end

  def good_area#метод площади возвращающий метод хороших граней
    result = 0.0#начало суммы 0

    facets.each do |face|#цикл по всем граням
    #если грань хорошая то добавляем площадь грани в нашу сумму
      result += face.area if face.good?
    end

    return result#возвращаем сумму
  end
end
