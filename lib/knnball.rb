# encoding: UTF-8
require 'descriptive_statistics'

module KnnBall

  autoload :Ball, "./lib/knnball/ball.rb"
  autoload :Stat, "./lib/knnball/stat.rb"
  autoload :KDTree, "./lib/knnball/kdtree.rb"
  autoload :ResultSet, "./lib/knnball/result_set.rb"

  # Retrieve a new BallTree given an array of input values.
  #
  # Each data entry in the array is a Hash containing
  # keys :value and :point, an array of position (one per dimension)
  # [ {:value => 1, :point => [1.23, 2.34, -1.23, -22.3]},
  # {:value => 2, :point => [-2.33, 4.2, 1.23, 332.2]} ]
  #
  # @param data an array of Hash containing :value and :point key
  #
  # @see KnnBall::KDTree#initialize
  def self.build(data)
    if(data.nil? || data.empty?)
      raise ArgumentError.new("data argument must be a not empty Array")
    end

    # 取出维度
    # 创建n维度的树
    # 然后生成树
    max_dimension = data.first[:point].size
    kdtree = KDTree.new(max_dimension)
    kdtree.root = generate(data, max_dimension)
    return kdtree
  end

  # Generate the KD-Tree hyperrectangle.
  #
  # @param actual_dimension the dimension to base comparison on
  # @param max_dimension the number of dimension of each points
  # @param data the list of all points
  # @param left the first data index to look for
  # @param right the last data index to look for
  def self.generate(data, max_dimension, actual_dimension = 1)
    return nil if data.nil?
    return Ball.new(data.first) if data.size == 1

    # Order the array such as the middle point is the median and
    # that every point on the left are of lesser value than median
    # and that every point on the right are of greater value
    # than the median. They are not more sorted than that.
    median_idx = median_index(data) # 数组的中间数

    # value = Stat.median!(data) {|v1, v2| v1[:point][actual_dimension-1] <=> v2[:point][actual_dimension-1]}
    data.sort_by! { |index| index[:point][actual_dimension-1] }
    # offset = (data.size % 2 == 0) ? (data.size / 2) : (data.size - 1) / 2
    value = data[median_idx]
    ball = Ball.new(value)

    actual_dimension = (max_dimension == actual_dimension ? 1 : actual_dimension)
    

    ball.left = generate(data[0..(median_idx-1)], (visible_dimension ), actual_dimension) if median_idx > 0
    ball.right = generate(data[(median_idx+1)..-1], max_dimension, actual_dimension) if median_idx < (data.count - 1)
    return ball
  end

  def self.median_index(data)
    (data.size % 2 == 0) ? (data.size / 2) : (data.size - 1) / 2
  end

  # visualization
  def self.visible_dimension data
    points_arr = data.map { |e| e[:point] }.transpose
    points_arr.map(&:variance).each_with_index.max[1]
  end

end