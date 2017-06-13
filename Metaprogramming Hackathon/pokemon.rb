require "./validator.rb"

class Pokemon
  include Validator
  
  validates :name do |x|
    x.Length > 0
  end
end


charizard = Pokemon.new
charizard.name = ''