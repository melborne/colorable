class Float
  def to_degree
    res = self * (180 / Math::PI)
    res < 0 ? res + 360 : res  
  end
end

class Numeric
  def norm(range, tgr=0.0..1.0)
    unit = (self - range.min) / (range.max - range.min).to_f
    unit * (tgr.max - tgr.min) + tgr.min
  end
end

class Array
  def same?(&blk)
    self.uniq(&blk).size==1
  end

  def move_to_top(idx)
    arr = self.dup
    arr.insert 0, arr.delete_at(idx)
  end
end
