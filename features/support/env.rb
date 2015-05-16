require 'aruba/cucumber'

require 'dotenv'
Dotenv.load

ROOTDIR=File.join(File.dirname(__FILE__), '..', '..')
require File.join(ROOTDIR, 'spec', 'example.rb')
require 'main'
