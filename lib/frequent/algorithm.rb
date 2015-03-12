require 'frequent/version'

module Frequent

  class Algorithm
    attr_reader :n, :b, :k
    
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
    end

    def process(item)
      raise NotImplementedError.new
    end

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
