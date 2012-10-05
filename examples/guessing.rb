#!/usr/bin/ruby

require 'reconsidered'

num = Random.rand 10
puts "I'm thinking of a number between 1 and 10."

__label__ :guess
print "Can you guess it? "
guess = gets.to_i
if num != guess
  puts "Wrong!"
  __goto__ :guess
else
  puts "Right!"
end
