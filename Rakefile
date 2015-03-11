# coding: utf-8
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/clean'
CLEAN.include('pkg/*.gem')
CLOBBER.include('pkg')

desc 'Execute unit tests'
task :test do
  ruby %{ test/test_frequent-algorithm.rb }
end

task default: [:test]
