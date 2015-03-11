# coding: utf-8
$:.unshift('lib')
require 'frequent/version'

Gem::Specification.new do |s|
  s.name = 'frequent-algorithm'
  s.version = Frequent::VERSION
  s.license = 'MIT'
  s.summary = 'A Ruby implementation of the FREQUENgem leveraging FFI (foreign function interface), frequent combines the Ruby programming language with MeCab, the part-of-speech and morphological analyzer for the Japanese language.'
  s.description = <<END_DESC
No compiler is necessary, as frequent is not a C extension. It will run on CRuby (mri/yarv) and JRuby (jvm) equally well. It will also run on Windows, Unix/Linux, and OS X. frequent provides a naturally Ruby-esque interface to MeCab.
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
