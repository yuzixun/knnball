# encoding: UTF-8

module KnnBall
  class ResultSet
    attr_reader :limit, :threshold_value

    def initialize(options = {})
      @limit = options[:limit] || 10
      @items = []
      @threshold_value = options[:threshold_value]
    end

    def eligible?(value)
      # 以下三种情况，允许插入点
      # 1. 阈值为空
      # 2. 结果队列未满
      # 3. 当前距离 小于 阈值
      @threshold_value.nil? || @items.size < limit || value < @threshold_value
    end

    def add(value, item)
      return false unless(eligible?(value))

      if @threshold_value.nil? || @items.nil? || value > @threshold_value
        # 以下三种情况，直接在队列尾部追加点
        # 1. 阈值为空
        # 2. 结果队列为空
        # 3. 当前距离 大于 阈值
        @threshold_value = value
        @items.push [value, item]
      else
        # 插入到合适位置中
        index = 0
        while(index < @items.size && value > @items[index][0])
          index = index + 1
        end
        @items.insert index, [value, item]
      end

      # 如果结果队列中的数量，则把最后一个点推出
      if @items.size > limit
        @items.pop
      end

      # 将队列最后一个点的距离，设置为阈值
      @threshold_value = @items.last[0]
      return true
    end

    def items
      # @items 的存储结构是 [value, point]
      # 封装方法，将value过滤掉，只返回point
      @items.map {|i| i[1]}
    end
  end
end
