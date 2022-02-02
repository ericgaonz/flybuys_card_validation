require 'minitest/autorun'
require './card.rb'

class CardTest < MiniTest::Unit::TestCase
  def test_is_16_or_17_digit_black_card
    card = Card.new("6014100000000016")
    card.set_prefix
    assert_equal card.prefix, 'Fly Buys Black'

    card = Card.new("60141000000000017")
    card.set_prefix
    assert_equal card.prefix, 'Fly Buys Black'
  end
  def test_is_not_16_and_17_digit_black_card
    card = Card.new("601410000000015")
    card.set_prefix
    assert_equal card.prefix, 'Unknown'
  end

  def test_is_16_digit_red_card
    card = Card.new("6014352000000016")
    card.set_prefix
    assert_equal card.prefix, 'Fly Buys Red'
  end
  def test_is_not_16_digit_red_card
    card = Card.new("601435200000015")
    card.set_prefix
    assert_equal card.prefix, 'Unknown'
  end

  def test_is_16_digit_green_card
    card = Card.new("6014355526000016")
    card.set_prefix
    assert_equal card.prefix, 'Fly Buys Green'
  end
  def test_is_not_16_digit_green_card
    card = Card.new("601435552600015")
    card.set_prefix
    assert_equal card.prefix, 'Unknown'
  end

  def test_is_16_digit_blue_card
    card = Card.new("6014555526000016")
    card.set_prefix
    assert_equal card.prefix, 'Fly Buys Blue'
  end
  def test_is_not_16_digit_blue_card
    card = Card.new("601455552600015")
    card.set_prefix
    assert_equal card.prefix, 'Unknown'
  end

  def test_is_valid_card
    card = Card.new("60141016700078611")
    card.valid?
    assert_equal card.validity, 'valid'
  end
  def test_is_invalid_card
    card = Card.new("6014152705006141")
    card.valid?
    assert_equal card.validity, 'invalid'
  end
end
