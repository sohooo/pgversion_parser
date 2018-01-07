$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pgversion'

require 'minitest/autorun'

# Enables rainbow-coloured test output.
require 'minitest/pride'

# Enables parallel (multithreaded) execution for all tests.
require 'minitest/hell'
