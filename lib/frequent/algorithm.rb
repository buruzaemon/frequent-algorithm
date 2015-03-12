require 'frequent/version'

module Frequent

  class Algorithm
    # @return [Integer] the number of items in the main window
    attr_reader :n
    # @return [Integer] the number of items in a basic window
    attr_reader :b
    # @return [Integer] the number of top item categories to track
    attr_reader :k
    # @return [Array<Hash<Object,Integer>>] global queue for storing basic windows
    attr_reader :queue
    # @return [Hash<Object,Integer>] global queue for storing basic windows
    attr_reader :statistics
    # @return [Integer] global variable for basic windows delta
    attr_reader :delta
    
    # Initializes this frequency-calculating instance.
    # 
    # @param [Integer] n number of items to store in the main window
    # @param [Integer] b number of items to store in a basic window (less than n)
    # @param [Integer] k number of top item categories to track
    def initialize(n, b, k=1)
      if n <= 0
        raise ArgumentError.new('n must be greater than 0')
      end
      if b <= 0
        raise ArgumentError.new('b must be greater than 0')
      end
      if k <= 0
        raise ArgumentError.new('k must be greater than 0')
      end
      if n/b < 1
        raise ArgumentError.new('n/b must be greater than 1')
      end
      @n = n
      @b = b
      @k = k

      @queue = [] 
      @statistics = {}
      @delta = 0
    end

    # Processes a single item, by first adding it to a basic
    # window in the internal global queue; and then updating 
    # the global statistics accordingly.
    # 
    # @param [Object] a countable, immutable object.
    def process(item)
      raise NotImplementedError.new
    end

    # Returns the version for this gem.
    #
    # @return [String] the version for this gem.
    def version
      Frequent::VERSION
    end
  end
end

=begin

  The MIT License (MIT)
  
  Copyright (c) 2015 Willie Tong, Brooke M. Fujita
  
  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the 
  Software is furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.

=end
