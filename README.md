# # 验证方法
# result.each do |r|
#   puts "distance to #{r} is #{distance(r[:point], input_point)}"
# end

def distance(from, to)
  [from, to].transpose.map {|a,b| (b - a)**2}.reduce {|d1,d2| d1 + d2}
end