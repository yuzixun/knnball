# encoding: UTF-8
require 'descriptive_statistics'

module KnnBall

  autoload :Ball, "./lib/knnball/ball.rb"
  autoload :KDTree, "./lib/knnball/kdtree.rb"
  autoload :ResultSet, "./lib/knnball/result_set.rb"

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

  def self.generate(data, max_dimension, actual_dimension = 1)
    return nil if data.nil?
    return Ball.new(data.first) if data.size == 1

    # 数组的中间数
    median_idx = median_index(data)
    # 将指定维度的数据排序
    data.sort_by! { |index| index[:point][actual_dimension-1] }
    # 取出中间的值，作为根节点
    value = data[median_idx]
    ball = Ball.new(value)

    # 默认取第一维度
    actual_dimension = (max_dimension == actual_dimension ? 1 : actual_dimension)

    ball.left = generate(data[0..(median_idx-1)], max_dimension, actual_dimension) if median_idx > 0
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