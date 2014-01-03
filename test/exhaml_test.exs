defmodule ExhamlTest do
  use ExUnit.Case

  import Exhaml

  test "the truth" do
    assert(true)
  end

  test "Exhaml.Compiler.compile test" do
  	assert compile("%p asd") == :mock
  end

end
