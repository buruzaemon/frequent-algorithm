# coding: utf-8
require 'frequent/version'

module Frequent

  ERR_BADLIST = "List cannot be nil or empty".freeze
  ERR_BADK = "k must be between 1 and %s".freeze

  # `Frequent::Algorithm` is the Ruby implementation of the
  # Demaine et al. FREQUENT algorithm for calculating 
  # top-k items in a stream.
  #
  # The aims of this algorithm are:
  # * use limited memory
  # * require constant processing time per item
  # * require a single-pass only
  #
  class Algorithm
    # @return [Integer] the number of items in the main window
    attr_reader :n
    # @return [Integer] the number of items in a basic window
    attr_reader :b
    # @return [Integer] the number of top item categories to track
    attr_reader :k
    # @return [Array<Hash<Object,Integer>>] global queue for basic window summaries
    attr_reader :queue
    # @return [Hash<Object,Integer>] global mapping of items and counts
    attr_reader :statistics
    # @return [Integer] minimum threshold for membership in top-k items
    attr_reader :delta

    # Initializes this top-k frequency-calculating instance.
    # 
    # @param [Integer] n number of items in the main window
    # @param [Integer] b number of items in a basic window
    # @param [Integer] k number of top item categories to track
    # @raise [ArgumentError] if n is not greater than 0
    # @raise [ArgumentError] if b is not greater than 0
    # @raise [ArgumentError] if k is not greater than 0
    # @raise [ArgumentError] if n/b is not greater than 1
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

    # Processes a single basic window of b items, by first adding
    # a summary of this basic window in the internal global queue;
    # and then updating the global statistics accordingly.
    # 
    # @param [Array] an array of objects representing a basic window
    def process(elements)
      # Do we need this?
      return if elements.length != @b

      # Step 1
      summary = {}
      elements.each do |e|
        if summary.key? e
          summary[e] += 1
        else
          summary[e] = 1
        end
      end

      # index of the k-th item
      kth_index = find_kth_largest(summary)

      # Step 2 & 3
      # summary is [[item,count],[item,count],[item,count]....]
      # sorted by descending order of the item count
      summary = summary.sort { |a,b| b[1]<=>a[1] }[0..kth_index]
      @queue << summary

      # Step 4
      summary.each do |t|
        if @statistics.key? t[0]
          @statistics[t[0]] += t[1]
        else
          @statistics[t[0]] = t[1]
        end
      end

      # Step 5
      @delta += summary[kth_index][1]

      # Step 6
      if should_pop_oldest_summary
        # a
        summary_p = @queue.shift
        @delta -= summary_p[find_kth_largest(summary_p)][1]

        # b
        summary_p.each { |t| @statistics[t[0]] -= t[1] }
        @statistics.delete_if { |k,v| v <= 0 }

        #c
        @statistics.select { |k,v| v > @delta }
      else
        {}
      end
    end

    # Returns the version for this gem.
    #
    # @return [String] the version for this gem.
    def version
      Frequent::VERSION
    end

    private
    # Return true when it is ready to pop oldest summary from queue
    #
    # @return [Boolean] whether it is ready to pop oldest summary from queue
    def should_pop_oldest_summary
      @queue.length > @n/@b
    end

    # Return the k-th index of a summary object
    #
    # @param [Object] a summary object
    # @return [Integer] the k-th index
    def find_kth_largest(summary)
      [summary.length, @k].min - 1
    end

    # Return the kth largest element in the given list.
    #
    # @param [Array] list of integers
    # @return [Integer] the k-th largest element in list
    def kth_largest(list, k)
      raise ArgumentError.new(ERR_BADLIST) if list.nil? or list.empty?
      raise ArgumentError.new(ERR_BADK) if k < 1 or k > list.size

      def quickselect(ulist, k)
        p = rand(ulist.size)

        lower = ulist.select { |e| e < ulist[p] }
        upper = ulist.select { |e| e > ulist[p] }

        if k <= lower.size
          quickselect(lower, k)
        elsif k > ulist.size - upper.size
          quickselect(upper, k - (ulist.size - upper.size))
        else
          ulist[p]
        end
      end
      quickselect(list, list.size+1-k)
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
