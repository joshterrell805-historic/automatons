if ENV['COVERAGE']
   require 'simplecov'
end
require 'aruba/cucumber'

require 'dotenv'
# Load standard .env
Dotenv.load
# Load test environment. Overwrite standard environment
Dotenv.overload ".env.test"

ROOTDIR=File.join(File.dirname(__FILE__), '..', '..')
require File.join(ROOTDIR, 'spec', 'example.rb')
require 'main'

if RUBY_PLATFORM == 'java'
   require 'aruba/jruby'
   ENV['CLASSPATH'] = File.absolute_path '.'
end
