require './card.rb'

numbers = IO.readlines(ARGV.first)

numbers.each do |number|
    card = Card.new(number)
    card.attrs_initialize
    card.show()
end
