# # iteration 1
# class Pet
#   attr_reader :name, :type
#   def initialize(type, name)
#     @type = type
#     @name = name
#   end
# end

# class Owner
#   attr_reader :name
#   attr_accessor :number_of_pets

#   def initialize(name)
#     @name = name
#     @number_of_pets = 0
#   end
# end

# class Shelter
#   attr_reader :client_history

#   def initialize
#     @client_history = Hash.new { |hash, key| hash[key] = [] }
#   end

#   def adopt(owner, pet)
#     owner.number_of_pets += 1
#     client_history[owner.name] << [pet.type, pet.name]
#   end

#   def print_adoptions
#     client_history.each do |name, pets|
#       puts "#{name} has adopted the following pets:"
#       pets.each do |pair|
#         puts "a #{pair.first} named #{pair.last}"
#       end
#     end
#   end
# end

# iteration 2
class Pet
  attr_reader :type, :name
  def initialize(type, name)
    @type = type
    @name = name
  end

  def to_s
    "a #{type} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    pets << pet
  end

  def number_of_pets
    pets.size
  end

  def print_pets
    pets.each do |pet|
      puts pet
    end
  end
end

class Shelter
  attr_reader :client_history

  def initialize
    @client_history = []
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    client_history << owner unless client_history.include?(owner)
  end

  def print_adoptions
    client_history.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.print_pets  
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.