# This works
class Machine
  
  def start
    self.flip_switch(:on)
  end
  
  def stop
    self.flip_switch(:off)
  end
  
  private
  attr_writer :switch
  
  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

# This is more idiomatic
class Machine
  
  def start
    flip_switch(:on)
  end
  
  def stop
    flip_switch(:off)
  end
  
  private
  attr_writer :switch
  
  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

# Prior to Ruby 2.7, the crux of the problem is the asymmetry of 
# two different rules regarding method calls depending on if the
# private method is a normal method or if it is a setter method.
# Prior to Ruby 2.7, a normal private method cannot be called
# with `self`. However, a private setter method must be called
# with `self` to disambiguate from a local variable being
# initialized. After Ruby 2.7, it became acceptable to call a 
# private method with `self`, e.g., `self.flip_switch`

# Further Exploration
class Machine
  
  def start
    self.flip_switch(:on)
  end
  
  def stop
    self.flip_switch(:off)
  end

  def show_state
    switch
  end
  
  private
  attr_accessor :switch
  
  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

# LSBot suggestions:
# Initial state: `show_state` will return `nil` until 
# `start`/`stop` is called. To have a defined state from the
# beginning, set it in `initialize` method, e.g., `@switch = :off`
# API clarity: if the plan is to expose state information, 
# consider query methods that express intent, e.g., `def on? /
# switch == :on / end`