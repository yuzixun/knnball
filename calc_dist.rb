#!/usr/bin/ruby
require "./lib/knnball.rb"

points = []

# 共434874个点
file = File.open("./3D_spatial_network.txt")
file.readlines.each do |line|
  elements = line.chop.split(',')
  points << {
    id: elements.shift.to_i,
    point: elements.map(&:to_f)
  }
end

index = KnnBall.build(points)

# input_point = [9.2796605, 56.7367747, 17.3937648136634]
# result = index.nearest(input_point, limit: 5)
puts "Ready to Calculate..."
while true
  puts "please inputs points: "

  input = gets.chop
  if input.include? ","
    input_point = input.split(",").map(&:to_f)
  else
    input_point = []
    input_point << input
    input_point << gets.chop.to_f
    input_point << gets.chop.to_f
  end

  result = index.nearest(input_point, limit: 3)

  puts result
end
