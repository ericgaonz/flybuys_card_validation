class Card
    attr_accessor :prefix, :number, :validity

    PREFIXES = {
        'Black' => 'Fly Buys Black',
        'Red' => 'Fly Buys Red',
        'Green' => 'Fly Buys Green',
        'Blue' => 'Fly Buys Blue',
        'Other' => 'Unknown'
    }

    def initialize(cardNumber)
        @number = cardNumber.delete(" \t\r\n")
    end

    def set_prefix()
        size = @number.size()
        if @number.start_with?("60141") && (size == 16 || size == 17)
            @prefix = PREFIXES['Black']
        elsif @number.start_with?("6014352") && size == 16
            @prefix = PREFIXES['Red']
        elsif @number[0, 10].to_i >= 6014355526 && @number[0, 10].to_i <= 6014355529 && size == 16
            @prefix = PREFIXES['Green']
        elsif @number.start_with?("6014") && size == 16
            @prefix = PREFIXES['Blue']
        else
            @prefix = PREFIXES['Other']
        end 
    end

    def valid?
        is_second = false
        sum = 0
        (@number.size() - 1).downto(0) do |i|
            value = is_second ? @number[i].to_i * 2 : @number[i].to_i
            if value >= 10
                values = value.to_s
                value = values[0].to_i + values[1].to_i
            end

            sum += value
            is_second = !is_second
        end

        @validity = sum % 10 == 0 ? "valid" : "invalid"
    end

    def attrs_initialize
        set_prefix
        valid?
    end

    def show
        puts "#{@prefix}: #{@number} (#{@validity})"
    end
end
