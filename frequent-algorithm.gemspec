# coding: utf-8
$:.unshift('lib')
require 'frequent/version'

Gem::Specification.new do |s|
  s.name = 'frequent-algorithm'
  s.version = Frequent::VERSION
  s.license = 'MIT'
  s.summary = 'Identifies frequent items in a data stream in sliding windows using the Demaine et al FREQUENT algorithm.'
  s.description = <<END_DESC
frequent-algorithm is a Ruby implementation of the Demaine et al FREQUENT algorithm for identifying frequent items in a data stream in sliding windows (c.f Identifying Frequent Items in Sliding Windows over On-Line Packet Streams, 2003).
END_DESC
  s.authors = ['Willie Tong', 'Brooke M. Fujita']
  s.email = ['tongsinyin@gmail.com', 'buruzaemon@gmail.com']
  s.homepage = 'https://github.com/buruzaemon/frequent-algorithm'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.require_path = 'lib'
  s.files = [
    'lib/frequent-algorithm.rb', 
    'lib/frequent/algorithm.rb', 
    'lib/frequent/version.rb', 
    'README.md',
    'LICENSE', 
    'CHANGELOG',
    '.yardopts'
  ]
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
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
