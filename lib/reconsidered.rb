# This gem provides the classical "GO TO" statement for Ruby
#
# Author::    Jim Wise  (mailto:jwise@draga.com)
# Copyright:: Copyright (c) 2012 Jim Wise
# License::   2-clause BSD-Style (see LICENSE[link:files/LICENSE.html])

require 'continuation' unless RUBY_VERSION.start_with?("1.8")

module Reconsidered
  VERSION = '0.9'

  # Exception thrown if you __goto__ a non-existent label
  class NoSuchLabel < StandardError
  end

  class Labels
    # Allocate a new private Label set.  Usually not needed -- use Kernel#__label__
    # and Kernel#__goto__ isnstead.
    #
    # See "Private Labels" in the README for details
    def initialize
      @labels = {}
    end

    # Create a new label which, when used with #goto, will return to the current
    # location in the program
    def label sym
      callcc do |cc|
        @labels[sym] = cc
      end
    end

    # Return to the location in the code labeled with sym
    def goto sym
      raise NoSuchLabel unless @labels[sym].instance_of? Continuation
      @labels[sym].call
    end
  end

  # :nodoc:
  Default_Labels = Labels.new
end

module Kernel  
  # Create a new label which, when used with __goto__, will return to the current
  # location in the program
  def __label__ sym
    Reconsidered::Default_Labels.label sym
  end

  # Return to the location in the code labeled with sym
  def __goto__ sym
    Reconsidered::Default_Labels.goto sym
  end
end
