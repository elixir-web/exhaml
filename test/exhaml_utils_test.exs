defmodule ExhamlUtilsTest do
  use ExUnit.Case

  import ExHaml.Utils

  test "ExHaml.Utils.is_next_is_symbol test" do
  	assert is_next_is_symbol("%p asd") == true
  	assert is_next_is_symbol(" %p asd") == false
  	assert is_next_is_symbol("	%p asd") == false
  	assert is_next_is_symbol("p asd") == true
  	assert is_next_is_symbol("ыp asd") == true
  end

end
