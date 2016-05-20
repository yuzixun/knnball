# encoding: UTF-8

module KnnBall
  class Ball
    attr_accessor :left, :right, :value, :dimension

    def initialize(value, dimension = 1, left = nil, right = nil)
      unless (value.respond_to?(:include?) && value.respond_to?(:[]))
        raise ArgumentError.new("Value must at least respond to methods include? and [].")
      end
      unless (value.include?(:point))
        raise ArgumentError.new("value must contains :point key but has only #{value.keys.inspect}")
      end
      @value = value
      @right = right
      @dimension = dimension
      @left = left
    end

    def center
      value[:point]
    end

    # 不求距离，求出距离的平方值即可
    def distance(coordinates)
      coordinates = coordinates.center if coordinates.respond_to?(:center)
      [center, coordinates].transpose.map {|a,b| (b - a)**2}.reduce {|d1,d2| d1 + d2}
    end

    def leaf?
      @left.nil? && @right.nil?
    end

    def complete?
      ! (@left.nil? || @right.nil?)
    end

  end
end