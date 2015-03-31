$: << 'lib'
require 'frequent-algorithm'

if __FILE__ == $0
  f = File.join(File.expand_path(File.dirname(__FILE__)),
                                 'corpora',
                                 'odyssey.mb.txt')
  enum = File.foreach(f)
  # the Odyssey begins at line 12 and spans 10412 lines
  12.times { enum.next }
  puts enum.next
  10411.times { enum.next }
  puts enum.next

end
