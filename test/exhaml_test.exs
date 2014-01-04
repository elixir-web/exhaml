defmodule ExhamlTest do
  use ExUnit.Case

  import Exhaml

  test "the truth" do
    assert(true)
  end

  test "Exhaml.Compiler.compile test" do
    assert compile("!!!  Strict  ") == [[:doctype, :doctype_xhtml_strict]]
    assert compile("!!!  5  ") == [[:doctype, :doctype_html5]]
  end

end