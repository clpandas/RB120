# class Banner
#   def initialize(message)
#     @message = message
#     @banner_width = message.length + 2
#   end

#   def to_s
#     [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
#   end

#   private

#   attr_reader :banner_width

#   def horizontal_rule
#     "+" + ("-" * banner_width) + "+"
#   end

#   def empty_line
#     "|" + (" " * banner_width) + "|"
#   end

#   def message_line
#     "| #{@message} |"
#   end
# end

# # LS Solution:
# class Banner
#   def initialize(message)
#     @message = message
#   end

#   def to_s
#     [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
#   end

#   private

#   def empty_line
#     "| #{' ' * (@message.size)} |"
#   end

#   def horizontal_rule
#     "+-#{'-' * (@message.size)}-+"
#   end

#   def message_line
#     "| #{@message} |"
#   end
# end

# My solution refactored:
class Banner
  def initialize(message)
    @message = message
    @banner_width = message.length
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  attr_reader :banner_width

  def horizontal_rule
    "+-#{"-" * banner_width}-+"
  end

  def empty_line
    "| #{" " * banner_width} |"
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+
 
banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+