class Fixnum

  def delimited(delimiter=",")
    self.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end

  def rounded_with_suffix
    number_commafied = self.delimited.split(",")
    case number_commafied.length
    when 1
      return number_commafied.first
    when 2
      return number_commafied.append_metric_prefix("K")
    when 3
      return number_commafied.append_metric_prefix("M")
    when 4
      return number_commafied.append_metric_prefix("B")
    when 5
      return number_commafied.append_metric_prefix("T")
    end
  end

  def twitter_utc_offset_to_normal_human_utc_offset
    hours = self.abs/3600
    minutes = (self.abs-hours*3600)/60
    sign = self > 0 ? "+" : "-"
    zero_before_hours = hours/10 == 0 ? "0" : ""
    zero_before_minutes = minutes/10 == 0 ? "0" : ""
    return "#{sign}#{zero_before_hours}#{hours}:#{zero_before_minutes}#{minutes}"
  end
  
  def is_nan?
    false
  end

  def year
    self*60*60*24*365
  end

  def month
    self*60*60*24*28
  end

  def week
    self*60*60*24*7
  end

  def day
    self*60*60*24
  end
  
  def hour
    self*60*60
  end
  
  alias :years :year
  alias :months :month
  alias :weeks :week
  alias :days :day
  alias :hours :hour
end
