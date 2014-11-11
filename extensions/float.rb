class Float
  def delimited(delimiter=",")
    self.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end
  
  def rounded_with_suffix
    self.to_i.rounded_with_suffix
  end
  
  def is_nan?
    impossible_set = [self > 0, self < 0, self == 0]
    return impossible_set.uniq.length == 1 && impossible_set.first == false
  end
end
