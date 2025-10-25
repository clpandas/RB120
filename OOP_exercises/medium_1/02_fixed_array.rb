class FixedArray
  def initialize(size)
    @array = Array.new(size)
  end

  def [](index)
    check_index(index)
    @array[index]
  end

  def []=(index, value)
    check_index(index)
    @array[index] = value
  end

  def to_a
    @array.clone #or dup
  end

  def to_s
    to_a.to_s
  end

  private

  def check_index(index)
    unless index.between?(-@array.size, @array.size - 1)
      raise IndexError, "Index #{index} is out of bounds"
    end
  end
end

# # LS solution
# class FixedArray
#   def initialize(max_size)
#     @array = Array.new(max_size)
#   end

#   def [](index)
#     @array.fetch(index)
#     # `Array#fetch` raises an `IndexError` if the index is out of bounds unless a default value or block is offered
#   end

#   def []=(index, value)
#     self[index]
#     @array[index] = value
#   end

#   def to_a
#     @array.clone
#   end
  
#   def to_s
#     to_a.to_s
#   end
# end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end