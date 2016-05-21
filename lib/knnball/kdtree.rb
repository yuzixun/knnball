# encoding: UTF-8

module KnnBall

  class KDTree
    attr_accessor :root

    def initialize(root = nil)
      @root = root
    end

    def nearest(coord, options = {})
      return nil if root.nil?
      return nil if coord.nil?

      # 设置获取结果数量
      results = (options[:results] ? options[:results] : ResultSet.new({limit: options[:limit] || 1}))
      # 设置根节点
      root_ball = options[:root] || root
      # 待回溯的点
      parents = []
      # 最优值
      current_best = nil

      current = root_ball

      # 未找到最优值
      while current_best.nil?
        # 取出展开的维度
        dim = current.dimension
        # 是否是一棵完全二叉树
        if(current.complete?)
          # 如果输入的值，小于等于节点的值，则进入左侧树，反之，进入右侧树
          next_ball = (coord[dim] <= current.center[dim] ? current.left : current.right)
        elsif(current.leaf?)
          # 设置下一个点为空
          next_ball = nil
        else
          # 如果 不是完全二叉树，则，取存在的节点
          next_ball = (current.left.nil? ? current.right : current.left)
        end
        if next_ball.nil?
          # 下一个点不存在了，则找到了最优值
          current_best = current
        else
          # 将点推入到队列中，等待回溯
          parents.push current
          current = next_ball
        end
      end

      # 倒转队列，从最后的节点开始计算
      parents.reverse!
      # 把最优值放入到 结果队列中
      results.add(current_best.distance(coord), current_best.value)
      parents.each do |current_node|
        # 计算当前节点到 到输入点 的距离
        dist = current_node.distance(coord)

        if results.eligible? dist
          results.add(dist, current_node.value)
        end

        dim = current_node.dimension
        if current_node.complete?
          split_node = (coord[dim] <= current_node.center[dim] ? current_node.right : current_node.left)
          best_dist = results.threshold_value
          # 输入点 到 节点 的垂直距离 比 阈值小，
          # 则 可能存在比阈值 更近的点
          if (coord[dim] - current_node.center[dim]).abs <= best_dist
            nearest(coord, root: split_node, results: results)
          end
        end
      end
      return results.limit == 1 ? results.items.first : results.items
    end
  end
end