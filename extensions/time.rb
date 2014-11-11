class Time
  def time_ago_in_minutes
    return (Time.now-self)/60
  end

  def time_ago_in_hours
    return (Time.now-self)/60/60
  end

  def time_ago_in_days
    return (Time.now-self)/24/60/60
  end
  
  def time_ago_in_weeks
    return (Time.now-self)/24/60/60/7
  end
  
  def time_ago_in_years
    return (Time.now-self)/24/60/60/365
  end
  
  def self.time_from_now_in_hash(time)
    distance = (time-Time.now).to_i
    days = distance/24/60/60
    distance -= 24*60*60*days
    hours = distance/60/60
    distance -= 60*60*hours
    minutes = distance/60
    distance -= 60*minutes
    seconds = distance
    return {:days => days, :hours => hours, :minutes => minutes, :seconds => seconds}
  end
  
  def self.time_from_now_in_words(time)
    time_hash = self.time_from_now_in_hash(time)
    time_term = ""
    [:days, :hours, :minutes, :seconds].each do |time_interval|
      time_term += time_hash[time_interval] == 1 ? "#{time_hash[time_interval]} #{time_interval.to_s.chop}, " : "#{time_hash[time_interval]} #{time_interval}, " if time_hash[time_interval] != 0
    end
    time_term.chop!.chop!
    return time_term
  end

  def self.me(&block)
    time_a = Time.now
      block.()
    time_b = Time.now
    time_b - time_a
  end
  
  def self.distance(time)
    time = Time.parse(time) if time.class != Time
    Time.now-time
  end

  def nice_format
    if (Time.now-self) < 60
      return "Just now"
    elsif (Time.now-self) < 60*60
      return "#{((Time.now-self)/60).to_i} minutes ago"
    elsif (Time.now-self) < 60*60*24
      hours = (Time.now-self)/(60*60)
      return "#{hours.to_i} hour#{hours.to_i == 1 ? "" : "s"} ago"
    else
      days = (Time.now-self)/(60*60*24)
      return "#{days.to_i} day#{days.to_i == 1 ? "" : "s"} ago"
    end
  end
  
  def standard_format
    self.strftime("%Y-%m-%d %H:%M:%S %Z")
  end

  def self.ago_from_word(word)
    case word
    when "day"
      return Time.now-1.day
    when "week"
      return Time.now-1.week
    when "month"
      return Time.now-1.month
    when "year"
      return Time.now-1.year
    end
  end
end