require "./lib/knnball.rb"

points = []

# # 共434874个点
file = File.open("./3D_spatial_network.txt")
file.readlines.each do |line|
  elements = line.chop.split(',')
  points << {
    id: elements.shift.to_i,
    point: elements.map(&:to_f)
  }
end

index = KnnBall.build(points)

result = index.nearest([9.2796605, 56.7367747, 17.3937648136634], limit: 3)
puts result # --> {:id=>2, :point=>[3.34444, 53.23259]}

# restults = index.nearest([3.43353, 52.34355, 8], :limit => 3)
# puts restults # --> [{...}, {...}, {...}]