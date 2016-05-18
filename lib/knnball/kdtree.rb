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

      root_ball = options[:root] || root

      # keep the stack while finding the leaf best match.
      parents = []

      best_balls = []
      in_target = []

      # Move down to best match
      current_best = nil
      current = root_ball
      while current_best.nil?
        # puts "current.dimension is #{current.inspect}"
        dim = current.dimension-1
        if(current.complete?)
          next_ball = (coord[dim] <= current.center[dim] ? current.left : current.right)
        elsif(current.leaf?)
          next_ball = nil
        else
          next_ball = (current.left.nil? ? current.right : current.left)
        end
        if ( next_ball.nil? )
          current_best = current
        else
          parents.push current
          current = next_ball
        end
      end

      # Move up to check split
      parents.reverse!
      results.add(current_best.distance(coord), current_best.value)
      parents.each do |current_node|
        dist = current_node.distance(coord)
        if results.eligible?( dist )
          results.add(dist, current_node.value)
        end

        dim = current_node.dimension-1
        if current_node.complete?
          # retrieve the splitting node.
          split_node = (coord[dim] <= current_node.center[dim] ? current_node.right : current_node.left)
          best_dist = results.barrier_value
          if( (coord[dim] - current_node.center[dim]).abs <= best_dist)
            # potential match, need to investigate subtree
            nearest(coord, root: split_node, results: results)
          end
        end
      end
      return results.limit == 1 ? results.items.first : results.items
    end
  end
end