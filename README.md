KnnBall
=======

KnnBall is a Ruby library that implements *Querying neareast neighbor algorithm*.
This algorithm optimize the search of the nearest point given a point as input.

It works with any number of dimension but essays seem to accord on the fact
that with more than 10 dimensions, brute force approach will give better results.

In this library, each point is associated to a value,
this way the library acts as an index for multidimensional data like
geolocation for example.


Usage
-----

    require 'knnball'

    data = [
    	{:id => 1, :point => [6.3299934, 52.32444]},
    	{:id => 2, :point => [3.34444, 53.23259]},
    	{:id => 3, :point => [4.22452, 53.243982]},
    	{:id => 4, :point => [4.2333424, 51.239994]},
        {:id => 5, :point => [3.43353, 53.23259]},
    	# ...
    ]

    index = KnnBall.build(data)

    result = index.nearest([3.43353, 52.34355])
    puts result # --> {:id=>2, :point=>[3.34444, 53.23259]}

    restults = index.nearest([3.43353, 52.34355], :limit => 3)
    puts result # --> [{...}, {...}, {...}]

Some notes about the above:

*data* is given using an array of hashes.
The only requirement of an Hash instance is
to have a :point key containing an array of coordinate.
in the documentation one of this Hash instance will be
called a *value* and the array of coordinates a *point*.
Sticking to built-in data-type will allow you to easily
use this tree without having to deal with homemade classes,
you might avoid a lot of conversion code this way. In the example
above, we added an :id key but you are not limited to that, you can
use any keys you want beyond the coord key. Keep in mind that the more
you put in this Hash, the more memory you will consume.

*index* is an instance of KnnBall::KDTree. The library rely on a k-dimensions
tree to store and retrieve the values. The nodes of the KDTree are Ball instance,
whoose class name refer to the theory of having ball containing smaller ball and so
on. In practice, this class does not behave like a ball, but by metaphore, it may help.

*KDTree#nearest* retrieve the nearest *value* of the given *point* by default or
the k nearest value if ':limit' optional argument is greater than 1.

Roadmap
-------

This project is not actively developed anymore. The code base is small, feel free to fork.

* Export and load using JSON
* Support the addition of new values
* Rebuild the tree


References
----------

This code was written with the help of the following ressources:

* Alorithms In a Nutshell ; George T. Heinemann, Gary Pollice & Stanley Selkow ; O'Reilly (chapter 4 and 9)
* Python SciPy kdnn module: http://scikit-learn.sourceforge.net/modules/neighbors.html
* Five Balltree Construction Algorithms, by Stephen M. Omohundro,  http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.8209&rep=rep1&type=pdf

Copyright (C) 2011 Olivier Amblet <http://olivier.amblet.net>

knnball is freely distributable under the terms of an MIT license.
See LICENSE or http://www.opensource.org/licenses/mit-license.php.