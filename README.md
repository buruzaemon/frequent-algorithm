# frequent-algorithm

Web site usage, social network behavior and Internet traffic are examples
of systems that appear to follow the [Power law](http://en.wikipedia.org/wiki/Power_law),
where most of the events are due to the actions of a very small few.
Knowing at any given point in time which items are trending is valuable
in understanding the system.

`frequent-algorithm` is a Ruby implementation of the FREQUENT algorithm
for identifying frequent items in a data stream in sliding windows.
Please refer to [Identifying Frequent Items in Sliding Windows over On-Line
Packet Streams](http://erikdemaine.org/papers/SlidingWindow_IMC2003/), by
Golab, DeHaan, Demaine, L&#243;pez-Ortiz and Munro (2003).

[![License](https://img.shields.io/badge/license-MIT-blue.svg)]() [![Build Status](https://travis-ci.org/buruzaemon/frequent-algorithm.svg?branch=master)](https://travis-ci.org/buruzaemon/frequent-algorithm) [![Gem Version](https://badge.fury.io/rb/frequent-algorithm.svg)](https://rubygems.org/gems/frequent-algorithm)

## Introduction

### Challenges

Challenges for Real-time processing of data streams for _frequent item queries_
include:

* data may be of unknown and possibly unbound length
* data may be arriving a very fast rate
* it might not be possible to go back and re-read the data
* too large a window of observation may include stale data

Therefore, a solution should have the following characteristics:

* uses limited memory
* can process events in the stream in &#927;(1) constant time
* requires only a single-pass over the data


### The algorithm 

> LOOP<br/>
> 1. For each element e in the next b elements:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;If a local counter exists for the type of element e:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Increment the local counter.<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;Otherwise:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create a new local counter for this element type<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;and set it equal to 1.<br/>
> 2. Add a summary S containing identities and counts of the k most frequent items to the back of queue Q.<br/>
> 3. Delete all local counters<br/>
> 4. For each type named in S:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;If a global counter exists for this type:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add to it the count recorded in S.<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;Otherwise:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create a new global counter for this element type<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;and set it equal to the count recorded in S.<br/>
> 5. Add the count of the kth largest type in S to δ.<br/>
> 6. If sizeOf(Q) > N/b:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;(a) Remove the summary S' from the front of Q and subtract the count of the kth largest type in S' from δ.<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;(b) For all element types named in S':<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subtract from their global counters the counts<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;recorded in S'<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If a counter is decremented to zero:<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete it.<br/>
> &nbsp;&nbsp;&nbsp;&nbsp;(c) Output the identity and value of each global counter > δ.
>
> &mdash; <cite>Golab, DeHaan, Demaine, López-Ortiz and Munro. Identifying Frequent Items in Sliding Windows over On-Line Packet Streams, 2003</cite>


## Usage

    require 'frequent-algorithm'

    # data is pi to 1000 digits
    pi = File.read('test/frequent/test_data_pi').strip
    data = pi.scan(/./).each_slice(b)
    
    N = 100  # size of main window
    b =  20  # size of basic window
    k =   3  # we are interested in top-3 numerals in pi
  
    alg = Frequent::Algorithm.new(N, b, k) 

    # read in and process the 1st basic window
    alg.process(data.next)

    # and the top-3 numerals are?
    top3 = alg.statistics.report
    puts top3

    # lather, rinse and repeat
    alg.process(data.next)
    

## Development 

The development of this gem requires the following:

* [Ruby 1.9.3 or greater](https://www.ruby-lang.org/en/)
* [rubygems](https://rubygems.org/pages/download)
* [`bundler`](https://github.com/bundler/bundler)
* [`rake`](https://github.com/ruby/rake)
* [`minitest`](https://rubygems.org/gems/minitest) (unit testing)
* [`yard`](https://rubygems.org/gems/yard) (documentation)
* [`rdiscount`](https://rubygems.org/gems/rdiscount) (Markdown)

Building, testing and release of this rubygem uses the following
`rake` commands:


    rake clean    # Remove any temporary products
    rake clobber  # Remove any generated file
    rake test     # Execute unit tests
    rake build    # Build frequent-algorithm-n.n.n.gem into the pkg directory
    rake install  # Build and install frequent-algorithm-n.n.n.gem into system gems
    rake release  # Create tag vn.n.n and build and push
                  # frequent-algorithm-n.n.n.gem to Rubygems


### Documentation

`frequent-algorithm` uses [`yard`](https://rubygems.org/gems/yard) and
[`rdiscount`](https://rubygems.org/gems/rdiscount) for Markdown documentation.
Check out [Getting Started with
Yard](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md).


### Unit Testing

`frequent-algorithm` uses
[`MiniTest::Unit`](https://github.com/seattlerb/minitest) for
unit testing.


### Releasing

Please refer to Publishing To Rubygems.org in the
[Rubygems Guide](http://guides.rubygems.org/make-your-own-gem/).


### Contributing

1. Fork it
2. Begin work on `dev-branch` (`git fetch && git checkout dev-branch`)
3. Create your feature branch (`git branch my-new-feature && git checkout
   my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature:dev-branch`)
6. Create new Pull Request

You may wish to read the [Git book online](http://git-scm.com/book/en/v2).


## Changelog

Please see the {file:CHANGELOG} for this gem's release history.


## License

frequent-algorithm is provided under the terms of the MIT license.

Copyright &copy; 2015, Willie Tong &amp; Brooke M. Fujita. All rights reserved. Please see the {file:LICENSE} file for further details.
