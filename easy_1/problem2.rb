# # Original
# class Pet
#   attr_reader :name

#   def initialize(name)
#     @name = name.to_s
#   end

#   def to_s
#     @name.upcase!
#     "My name is #{@name}."
#   end
# end

# name = 'Fluffy'
# fluffy = Pet.new(name)
# puts fluffy.name # Fluffy
# puts fluffy # My name is FLUFFY.
# puts fluffy.name # FLUFFY
# puts name # FLUFFY

# Debugged:
# The overriden `to_s` behavior only happens when it is called on a `Pet` object.
# Thus, it should not modify the instance variable as it will affect other parts of the code.
# The behavior should be encapsulated within the method, so the instance variable is not mutated. 
class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name # Fluffy
puts fluffy # My name is FLUFFY.
puts fluffy.name # Fluffy
puts name # Fluffy

# # Further exploration
# name = 42
# fluffy = Pet.new(name)
# name += 1 # this reassigns the number referenced by name to 43
# puts fluffy.name # 42
# puts fluffy # My name is 42.
# puts fluffy.name # 42
# puts name # 43

# - name on line 1 is a local variable assigned to the integer 42.
# - fluffy on line 2 is a local variable assigned to a Pet object with an instance variable name associated with the string "42" because of the Pet#initialize method. At this point, the instance variable @name and the local variable name point to two completely separate objects. 
# - On line 3 the local variable name is reassigned to reference the integer 43.
# - On line 4, the String#to_s method is implicitly invoked when puts is called on the object "42", which was returned by the name getter method.
# - On line 5, My name is 42. is returned because Pets#to_s is implicitly invoked when puts is called on a a Pet object.
# - On line 6, the same thing is happening as on line 4 (42 is output).
# - On line 7, Integer#to_s is implicitly invoked when puts is called on the local variable name, which had been reassigned to the integer 43.