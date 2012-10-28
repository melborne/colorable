class Float
  def to_degree
    res = self * (180 / Math::PI)
    res < 0 ? res + 360 : res  
  end
end