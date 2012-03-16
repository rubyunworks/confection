module Confection

  class HashBuilder

    def initialize(hash={}, &block)
      @hash = hash
      case block.arity
      when 0
        instance_eval(&block)
      else
        block.call(self)
      end
    end

    def to_h
      @hash
    end

    def method_missing(s, *a, &b)
      m = s.to_s
      if a.empty? && !b
        @hash[m.to_sym]
      else
        if b
          @hash[m.chomp('=').to_sym] = HashBuilder.new(&b).to_h
        else
          @hash[m.chomp('=').to_sym] = a.first
        end
      end
    end

  end

end
