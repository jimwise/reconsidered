require "test/unit"
require "reconsidered"

class TestReconsidered < Test::Unit::TestCase
  def test_simple
    acc = 0
    __label__ 10
    acc = acc + 1
    if acc < 10
      __goto__ 10
    end
    assert_equal 10, acc
  end

  def test_nosuchlabel
    assert_raise Reconsidered::NoSuchLabel do
      __goto__ 42
    end
  end

  # this is actually testing call/cc, but fine
  def test_after_exit
    flag = false
    @acc = 0
    def bar
      __label__ 20
      @acc = @acc + 1
    end
    bar
    unless flag
      flag = true
      __goto__ 20
    end
    assert_equal 2, @acc
  end

  def test_private
    l = Reconsidered::Labels.new
    acc = 0
    l.label 30
    acc = acc + 1
    if acc < 10
      l.goto 30
    end
    assert_raise Reconsidered::NoSuchLabel do
      __goto__ 30
    end
    assert_equal 10, acc
  end    
end
