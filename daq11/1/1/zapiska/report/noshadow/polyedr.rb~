# encoding: UTF-8
require "../common/polyedr"

class R3
  def length#
    Math.sqrt(@x*@x + @y*@y + @z*@z)#
  end

  def good?#хорошая вершина если она лежит больше чем сфера 
    @x*@x + @y*@y + @z*@z > 1#
  end
end

class Facet
  def area#метод площади
    result = 0.0#

    for i in 1 ... (vertexes.size - 1)#цикл от 1 до последней -1
      result += triangle_area(vertexes[0], vertexes[i], vertexes[i + 1])#
    end

    return 0.5*result#0.5* на результат
  end 

  def good?#метод вершин хороших
    vertexes.each do |vertex|#если вершина хорошая то делать 
      return false if !vertex.good?#вернем false если вершина не хорошая
    end

    return true#
  end

  private

  def triangle_area(a, b, c)#прощать треугольников расматриваем 
    ((b - a).v(c - a)).length#модуль векторов 
  end
end

class Polyedr 
  def draw
    TkDrawer.clean
    edges.each{|e| TkDrawer.draw_line(e.beg, e.end)}
  end

  def good_area#метод площади возвращающий метод хороших граний
    result = 0.0#начало суммы 0

    facets.each do |face|#цикл по всем граням
      result += face.area if face.good?#если грань хорошая то добавляем площадь грани в нашу сумму
    end

    return result#возвращаем сумму
  end
end
