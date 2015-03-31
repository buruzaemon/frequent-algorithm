$: << 'lib'
require 'frequent-algorithm'

PUNCT = /(\.|\"|\'s|,|\?|!|;|:")/

if __FILE__ == $0
  f = File.join(File.expand_path(File.dirname(__FILE__)),
                                 'corpora',
                                 'odyssey.mb.txt')
  enum = File.foreach(f)
  # the Odyssey begins at line 12 and spans 10412 lines
  12.times { enum.next }
  10412.times do 
    line = enum.next.strip.downcase
    words = line.gsub(PUNCT, '').split
    words.each do |w|
      #puts w
      # at this point, feed in the word w into the process method
    end
  end
end
