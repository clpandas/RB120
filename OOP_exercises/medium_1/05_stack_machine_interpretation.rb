# # Without exceptions or Object#send
# class Minilang
#   def initialize(program)
#     @commands = program.split
#     @register = 0
#     @stack = []
#   end

#   def eval
#     @commands.each do |command|
#       if integer?(command)
#         @register = command.to_i
#       else
#         success = execute(command)
#         return unless success
#       end
#     end
#   end

#   private
  
#   def execute(command)
#     case command
#     when 'PUSH' then @stack.push(@register)
#     when 'ADD' then operate(:+)
#     when 'SUB' then operate(:-)
#     when 'MULT' then operate(:*)
#     when 'DIV' then operate(:/)
#     when 'MOD' then operate(:%)
#     when 'POP' then pop_stack
#     when 'PRINT' then puts @register; true
#     else
#       puts "Invalid token: #{command}"
#       false
#     end
#   end

#   def operate(operator)
#     if @stack.empty?
#       puts"Empty stack!"
#       return false
#     end
#     @register = @register.send(operator, @stack.pop)
#     true
#   end

#   def pop_stack
#     if @stack.empty?
#       puts "Empty stack!"
#       return false
#     end
#     @register = @stack.pop
#     true
#   end

#   def integer?(token)
#     token.match?(/^[-]?\d+$/)
#   end
# end

# Refactored to include exceptions and Object#send
class MinilangError < StandardError; end
class EmptyStackError < MinilangError; end
class InvalidTokenError < MinilangError; end

class Minilang
  def initialize(program)
    @commands = program.split
    @register = 0
    @stack = []
  end

  def eval
    @commands.each do |command|
      if integer?(command)
        @register = command.to_i
      else
        execute(command)
      end
    end
  rescue MinilangError => error
    puts error.message
  end

  private

  def execute(command)
    if respond_to?(command.downcase, true)
      send(command.downcase)
    else
      raise InvalidTokenError, "Invalid token: #{command}"
    end
  end

  def push
    @stack.push(@register)
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def add
    @register += pop_value
  end

  def sub 
    @register -= pop_value
  end
  
  def mult
    @register *= pop_value
  end

  def div 
    @register /= pop_value
  end
  
  def mod 
    @register %= pop_value
  end

  def print
    puts @register
  end

  def pop_value
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @stack.pop
  end

  def integer?(token)
    token.match?(/^[-]?\d+$/)
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)