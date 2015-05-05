# coding: utf-8
require 'frequent/version'
require 'thread'

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
    # @return [Hash<Object,Integer>] latest top k elements and their counts
    attr_reader :topk
    # @return [Array[Object]] the window of elements of size b
    attr_reader :window

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
      @lock = Mutex.new

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
      @topk = {}
      @window = []
    end

    # Processes a single basic window of b items, by first adding
    # a summary of this basic window in the internal global queue;
    # and then updating the global statistics accordingly.
    # 
    # @param [Object] an object from a data stream
    def process(element)
      @lock.synchronize do
        @window << element
        if @window.length == @b 

          # Step 1
          summary = {}
          @window.each do |e|
            if summary.key? e
              summary[e] += 1
            else
              summary[e] = 1
            end
          end
          @window.clear   #current window cleared

          # Step 2
          @queue << summary

          # Step 3
          # Done, implicitly

          # Step 4
          summary.each do |k,v|
            if @statistics.key? k
              @statistics[k] += v
            else
              @statistics[k] = v
            end
          end

          # Step 5
          @delta += kth_largest(summary.values, @k)

          # Step 6 - sizeOf(Q) > N/b
          if @queue.length > @n/@b
            # a
            summary_p = @queue.shift
            @delta -= kth_largest(summary_p.values, @k)

            # b
            summary_p.each { |k,v| @statistics[k] -= v }
            @statistics.delete_if { |k,v| v <= 0 }

            #c
            @topk = @statistics.select { |k,v| v > @delta }
          end
        end
      end
    end

    # Return the latest Tok K elements
    #
    # @return [Hash<Object,Integer>] a hash which contains the current top K elements and their counts
    def report
      @topk
    end

    # Returns the version for this gem.
    #
    # @return [String] the version for this gem.
    def version
      Frequent::VERSION
    end

    private
    # Given a list of numbers and a number k which should be
    # between 1 and the length of the given list, return the
    # element x in the list that is larger than exactly k-1
    # other elements in the list.
    #
    # @param [Array] list of integers
    # @return [Integer] the kth largest element in list
    def kth_largest(list, k)
      raise ArgumentError.new(ERR_BADLIST) if list.nil? or list.empty?
      raise ArgumentError.new(ERR_BADK) if k < 1

      ulist = list.uniq
      k = ulist.size if k > ulist.size

      def quickselect(aset, k)
        p = rand(aset.size)

        lower = aset.select { |e| e < aset[p] }
        upper = aset.select { |e| e > aset[p] }

        if k <= lower.size
          quickselect(lower, k)
        elsif k > aset.size - upper.size
          quickselect(upper, k - (aset.size - upper.size))
        else
          aset[p]
        end
      end
      quickselect(ulist, ulist.size+1-k)
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
