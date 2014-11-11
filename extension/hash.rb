class Hash
  def invalidate_check(*keys)
    missing_keys = (keys.collect(&:to_sym)&self.keys.collect(&:to_sym))-keys.collect(&:to_sym)
    raise "Keys are missing in this Hash! Cannot continue. (Missing keys were #{missing_keys})" if !missing_keys.empty?
  end

  def parameterize
    URI.escape(self.collect{|k,v| "#{k}=#{v}" if v && !v.to_s.empty?}.compact.join('&'))
  end

  def map_values(&block)
    self.reduce({}) do |hash, (key, value)|
      hash.merge!(key => block.call(value))
    end
  end

  def method_missing(method, *args)
    if method.to_s.split("").last == "="
      self[method.to_s.gsub("=", "").to_sym] = args.first
    else
      if (self.keys|[method.to_s,method]).length != 0
        return self.values_at(method, method.to_s).compact.first
      else
        return nil
      end
    end
  end

  def to_schema
    self.reduce({}) do |init, (k, v)|
      if !v.class.ancestors.include?(Hash)
        init.merge({k => class_name(v)})
      else
        init.merge ({k => v.to_schema})
      end
    end
  end

  private
  def class_name(v)
    if v.class == Array 
      v.map(&:class).uniq.count == 1 ? [v.first.class] : v.map(&:class)
    else
      v.class
    end
  end

end