class Object
  def call_method_chain(method_chain)
    return self if method_chain.empty?
    method_chain.split('.').inject(self){|o,m| o.send(m.intern)}
  end
end