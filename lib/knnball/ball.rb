# encoding: UTF-8

module KnnBall
  # This class represents a ball in the tree.
  #
  # The value of this ball will be its center
  # while its radius is the distance between the center and
  # the most far sub-ball.
  class Ball
    attr_accessor :left, :right, :value, :dimension

    # @param value the value associated to this ball
    # @param actual_dimension the dimension used for sorting left and right tree
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

    # Retrieve true if this is a leaf ball.
    #
    # A leaf ball has no sub_balls.
    def leaf?
      @left.nil? && @right.nil?
    end

    # Return true if this ball has a left and a right ball
    def complete?
      ! (@left.nil? || @right.nil?)
    end

  end
end