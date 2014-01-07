defmodule ExhamlTest do
  use ExUnit.Case

  import Exhaml

  test "the truth" do
    assert(true)
  end

  test "Exhaml doctype test" do
    assert compile("!!! Strict  ") == [[:doctype, :doctype_xhtml_strict], [:indentation]]
    assert compile("  !!! Strict") == [[:indentation], [:doctype, :doctype_xhtml_strict]]
    assert compile("!!! 5  ") == [[:doctype, :doctype_html5], [:indentation]]
    assert compile("!!! 5  -#  asdsfg") == [[:doctype, :doctype_html5], [:indentation], [:comment]]
    assert compile("!!! 5  -#    asdsfg") == [[:doctype, :doctype_html5], [:indentation], [:comment]]
    assert compile("!!! 5   -# asdsfg") == [[:doctype, :doctype_html5], [:indentation], [" "], [:comment]]
  end

  test "Exhaml tag test" do
    assert compile("%p") == [{"p", [], []}]
    assert compile("%div") == [{"div", [], []}]
    assert compile("%div ") == [{"div", [], []}, [" "]]
    assert compile("%div  ") == [{"div", [], []}, [:indentation]]
    assert compile("%div   ") == [{"div", [], []}, [:indentation], [" "]]
    assert compile(" %div   ") == [{"div", [], []}, [:indentation], [" "]]
    assert compile("  %div") ==  [[:indentation], {"div", [], []}]
    assert compile("  %div") ==  [[:indentation], {"div", [], []}]
    assert compile("  %div  ") ==  [[:indentation], {"div", [], []}, [:indentation]]
    assert compile("    %div  ") ==  [[:indentation], [:indentation], {"div", [], []}, [:indentation]]
    assert compile("     %div  ") ==  [[:indentation], [:indentation], [" "], {"div", [], []}, [:indentation]]     
  end
  
end