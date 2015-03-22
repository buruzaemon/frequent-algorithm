# coding: utf-8

class TestAlgorithm < MiniTest::Unit::TestCase

  def setup
    @alg = Frequent::Algorithm.new(20,10,3)
 
    # test data: pi to 1000 digits
    @pi = File.read('test/frequent/test_data_pi').strip
  end

  def teardown
    @alg = nil
    @data = nil
  end

  def test_process
    data30 = @pi[0...30].scan(/./).each_slice(10).to_a

    # N = 20 items per main window
    # b = 10 items per basic window
    # k = 3 (top-3 numerals)
    topk = @alg.process(data30[0]) # only 1 summary in queue...
    # 3141592653
    assert_equal(1, @alg.queue.length)
    assert_equal(7, @alg.statistics.length)
    assert_equal(1, @alg.delta)
    assert_equal(0, topk.length)

    topk = @alg.process(data30[1]) # 2nd summary in queue...
    # 5897932384
    assert_equal(2, @alg.queue.length)
    assert_equal(9, @alg.statistics.length)
    assert_equal(2, @alg.delta)
    assert_equal(0, topk.length)

    # after reading in the N/b + 1, or 3rd, window,
    # we can now start getting answers to top-k query
    topk = @alg.process(data30[2]) # 3rd summary, delta updated
    # 6264338327
    assert_equal(2, @alg.queue.length)
    assert_equal(8, @alg.statistics.length)
    assert_nil(@alg.statistics['1'])
    assert_equal(2, @alg.delta)
    assert_equal(3, topk.length)
    assert_equal(5, topk['3'])
    assert_equal(3, topk['2'])
    assert_equal(3, topk['8'])
  end

  def test_summary_size_smaller_than_k
    # the 1st summary has 2 unique items only
    topk = @alg.process(%w(1 1 1 1 1 1 2 2 2 2)) # 1st summary in queue...
    assert_equal(1, @alg.queue.length)
    assert_equal(2, @alg.statistics.length)
    assert_equal(4, @alg.delta)
    assert_equal(0, topk.length)

    topk = @alg.process(%w(1 1 1 2 2 2 3 3 3 4)) #2nd summary in queue...
    assert_equal(2, @alg.queue.length)
    assert_equal(4, @alg.statistics.length)
    assert_equal(5, @alg.delta)
    assert_equal(0, topk.length)

    # after reading in the N/b + 1, or 3rd, window,
    # we can now start getting answers to top-k query
    # the first summary with 2 items was used as S'
    topk = @alg.process(%w(1 1 1 2 2 3 3 3 3 4)) # 3rd summary, delta updated
    assert_equal(2, @alg.queue.length)
    assert_equal(4, @alg.statistics.length)
    assert_equal(3, @alg.delta)
    assert_equal(3, topk.length)
    assert_equal(7, topk['3'])
    assert_equal(6, topk['1'])
    assert_equal(5, topk['2'])
  end

  def test_init
    assert_raises ArgumentError do
      Frequent::Algorithm.new(0,2)  
    end
    
    assert_raises ArgumentError do
      Frequent::Algorithm.new(2,0)  
    end
    
    assert_raises ArgumentError do
      Frequent::Algorithm.new(2, 2, 0)  
    end
    
    assert_raises ArgumentError do
      Frequent::Algorithm.new(3, 4, 0)  
    end

    assert_equal(0, @alg.queue.size)
    assert_equal(0, @alg.statistics.size)
    assert_equal(0, @alg.delta)
  end

  def test_kth_largest
    Frequent::Algorithm.expose_privates do

      assert_raises ArgumentError do
        @alg.kth_largest(nil, 6)
      end

      assert_raises ArgumentError do
        @alg.kth_largest([], 6)
      end

      a1 = [1,2,3,4,5]
      assert_equal(5, @alg.kth_largest(a1, 1))
      assert_equal(4, @alg.kth_largest(a1, 2))
      assert_equal(3, @alg.kth_largest(a1, 3))
      assert_equal(2, @alg.kth_largest(a1, 4))
      assert_equal(1, @alg.kth_largest(a1, 5))
      assert_equal(1, @alg.kth_largest(a1, a1.uniq.size+1))
      
      a2 = [2,2,4,4,1]
      assert_equal(4, @alg.kth_largest(a2, 1))
      assert_equal(2, @alg.kth_largest(a2, 2))
      assert_equal(1, @alg.kth_largest(a2, 3))
      assert_equal(1, @alg.kth_largest(a2, a2.uniq.size+1))

      a3 = [1,1,2,1,1,1]
      assert_equal(2, @alg.kth_largest(a3, 1))
      assert_equal(1, @alg.kth_largest(a3, 2))
      assert_equal(1, @alg.kth_largest(a3, a3.uniq.size+1))

      a4 = [1,1,1,1,1,1]
      assert_equal(1, @alg.kth_largest(a4, 1))
      assert_equal(1, @alg.kth_largest(a4, a4.uniq.size+1))
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
