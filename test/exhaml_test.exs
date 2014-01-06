defmodule ExhamlTest do
  use ExUnit.Case

  import Exhaml

  test "the truth" do
    assert(true)
  end

  def test1 do
    """
    !!! 5
      !!! 5
    """
  end

  def test2 do
    """
    !!! 5
      !!! 5
        !!!
    """
  end

  def test3 do
    """
    !!! 5
      !!! 5
      !!! 5
    """
  end

  def test4 do
    """
    !!! 5
      !!! 5
      !!! 5
    !!! 5
    """
  end

  def test5 do
    """
    !!! 5
    -# test test
      test test
      test test
    !!! 5
    """
  end

  def test6 do
    """
    !!! 5
      !!! 5
      !!! 5
    !!! 5
      !!! 5
        !!! 5
    """
  end

  test "Exhaml.Compiler.compile test" do
    assert compile("!!!  Strict  ") == [[:doctype, :doctype_xhtml_strict]]
    assert compile("!!!  5  ") == [[:doctype, :doctype_html5]]
    assert compile("!!!  5  -#  asdsfg") == [[:doctype, :doctype_html5], [:comment]]
    assert compile("!!!  5  -#     asdsfg") == [[:doctype, :doctype_html5], [:comment]]

    assert compile(test1()) == [[:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5]]
    assert compile(test2()) == [[:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5], [:indentation], [:indentation], [:doctype, :doctype_xhtml_transitional]]
    assert compile(test3()) == [[:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5]]  
    
    assert compile(test4()) == [[:doctype, :doctype_html5], 
                                  [:indentation], [:doctype, :doctype_html5], 
                                  [:indentation], [:doctype, :doctype_html5], 
                                [:doctype, :doctype_html5]]

    assert compile(test5()) ==  [[:doctype, :doctype_html5], [:comment], [:indentation], [:indentation], [:doctype, :doctype_html5]]
    assert compile(test6()) == [[:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5], [:doctype, :doctype_html5], [:indentation], [:doctype, :doctype_html5], [:indentation], [:indentation], [:doctype, :doctype_html5]]

  end

end