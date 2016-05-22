说明：
代码fork自：https://github.com/oliamb/knnball

本人做了一下修改：

1.  删除了test相关内容

2.  删除了Gemfile等文件

3.  原算法在选取排序维度时，默认使用了维度1。
    在这里引入了gem descriptive_statistics，做方差。
    选择方差较大的维度做排序。

Ruby运行环境：2.0.0+

所需Gem: descriptive_statistics

````
gem install descriptive_statistics
````

运行：

````
ruby calc_dist.rb
````

运行之后，输入点的经度、维度、高度
可以按照逗号分隔，也可以逐个输入。

Example:

````
Ready to Calculate...
Input Point: 
9.2796605, 56.7367747, 17.3937648136634
{:id=>95364858, :point=>[9.2796605, 56.7367747, 17.3937648136634]}
{:id=>100807699, :point=>[9.2522153, 56.7495346, 17.4036713946703]}
{:id=>100266584, :point=>[9.2860111, 56.7079333, 17.3704822385125]}
````