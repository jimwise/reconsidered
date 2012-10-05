# This gem provides the classical "GO TO" statement for Ruby
#
# Author::    Jim Wise  (mailto:jwise@draga.com)
# Copyright:: Copyright (c) 2012 Jim Wise
# License::   2-clause BSD-Style (see LICENSE[link:files/LICENSE.html])

require 'continuation' unless RUBY_VERSION.start_with?("1.8")

module Reconsidered
  VERSION = '0.9'

  class NoSuchLabel < StandardError
  end

  class Labels
    def initialize
      @labels = {}
    end

    def label sym
      callcc do |cc|
        @labels[sym] = cc
      end
    end

    def goto sym
      raise NoSuchLabel unless @labels[sym].instance_of? Continuation
      @labels[sym].call
    end
  end

  Default_Labels = Labels.new
end

module Kernel  
  def __label__ sym
    Reconsidered::Default_Labels.label sym
  end

  def __goto__ sym
    Reconsidered::Default_Labels.goto sym
  end
end
