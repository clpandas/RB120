# fixed size array
class CircularBuffer
  def initialize(size)
    @buffer = Array.new(size)
    @capacity = size
    @oldest_element = 0
    @count = 0
  end

  def put(item)
    if @count < @capacity
      idx = (@oldest_element + @count) % @capacity
      @count += 1
    else
      idx = @oldest_element
      @oldest_element = (@oldest_element + 1) % @capacity
    end
    @buffer[idx] = item
  end

  def get
    return nil if @count == 0
    next_value = @buffer[@oldest_element]
    @oldest_element = (@oldest_element + 1) % @capacity
    @count -= 1
    next_value
  end 
end

# # shift/append
# class CircularBuffer
#   def initialize(size)
#     @capacity = size
#     @buffer = []
#   end

#   def put(item)
#     if @buffer.size < @capacity
#       @buffer << item
#     else
#       @buffer.shift
#       @buffer << item
#     end
#   end

#   def get
#     @buffer.shift
#   end
# end


buffer = CircularBuffer.new(3)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

buffer = CircularBuffer.new(4)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 4
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil