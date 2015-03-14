$: << 'lib'
require 'frequent-algorithm'

if __FILE__ == $0

  # our basic parameters
  N = 100  # size of main window
  b =  20  # size of basic window
  k =   3  # top-3 numerals of pi
  
  # prep our algorithm instance
  alg = Frequent::Algorithm.new(N, b, k) 
  
  # read in the test data (pi to 1000 digits)
  # data includes decimal, and some random whitespace
  pi = File.read('test/frequent/test_data_pi').strip
  
  # split the data into separate chars,
  # and group into 1000/b arrays of b items each
  # data is a Generator
  data = pi.scan(/./).each_slice(b)
  
  # read in first basic window...
  #alg.process(data.next)
  
  # check global statistics state
  # puts alg.statistics
  # check global delta value
  # puts alg.delta
  
  puts "all done!"
end
