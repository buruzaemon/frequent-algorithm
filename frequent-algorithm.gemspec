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
  s.email = 'buruzaemon@gmail.com'
  s.homepage = 'https://github.com/buruzaemon/frequent-algorithm'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0'
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
end

# Copyright (c) 2015, Brooke M. Fujita.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
