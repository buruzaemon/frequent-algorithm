$: << 'lib'
require 'frequent-algorithm'

PUNCT = /(\.|\"|\'s|,|\?|!|;|:")/

if __FILE__ == $0

  alg = Frequent::Algorithm.new(500, 100, 5) 

  f = File.join(File.expand_path(File.dirname(__FILE__)),
                                 'corpora',
                                 'odyssey.mb.txt')
  enum = File.foreach(f)
  # the Odyssey begins at line 12 and spans 10412 lines
  12.times { enum.next }
  10412.times do |i|
    line = enum.next.strip.downcase
    words = line.gsub(PUNCT, '').split
    words.each do |w|
      # at this point, feed in the word w into the process method
      alg.process(w)
      if i>1000 && i%1000==0 && rand
        puts alg.report
      end
    end
  end
end
