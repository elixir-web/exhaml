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
    assert compile("%div  ") == [{"div", [], []}]
    assert compile("%div   ") == [{"div", [], []}, [" "]]
    assert compile(" %div   ") == [{"div", [], []}, [" "]]
    assert compile("  %div") ==  [[:indentation], {"div", [], []}]
    assert compile("  %div") ==  [[:indentation], {"div", [], []}]
    assert compile("  %div  ") ==  [[:indentation], {"div", [], []}]
    assert compile("    %div  ") ==  [[:indentation], [:indentation], {"div", [], []}]
    assert compile("     %div  ") ==  [[:indentation], [:indentation], [" "], {"div", [], []}]     
  end

  test "Parse text" do
    assert compile("test") == [["t"], ["e"], ["s"], ["t"]]
    assert compile("  test") == [[:indentation], ["t"], ["e"], ["s"], ["t"]]
    assert compile("   test") == [[:indentation], [" "], ["t"], ["e"], ["s"], ["t"]]
    assert compile("   test ") == [[:indentation], [" "], ["t"], ["e"], ["s"], ["t"], [" "]]
    assert compile("   test  ") == [[:indentation], [" "], ["t"], ["e"], ["s"], ["t  "]]
    assert compile("  %div test  ") == [[:indentation], {"div", [], []}, [" "], ["t"], ["e"], ["s"], ["t  "]] 
  end

  test "Parse tag with attributes" do
    assert compile("%div{test=>test}") == [{"div", [{"test", "=>", "test"}], []}, [" "]]
    assert compile("  %div{test=>test}") == [[:indentation], {"div", [{"test", "=>", "test"}], []}, [" "]]
    assert compile("   %div{ test=>test}") == [[:indentation], [" "], {"div", [{"test", "=>", "test"}], []}, [" "]]
    assert compile("%div{  test=>test}") == [{"div", [{"test", "=>", "test"}], []}, [" "]]
    assert compile("%div{  test=>test   }") == [{"div", [{"test", "=>", "test"}], []}, [" "]]
    assert compile("%div{ test => test, test2 => test2 }") == [{"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}], []}, [" "]]
    assert compile("%div{ test => test, test2 => test2,  test3 =>  test3 }") == [{"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}, {"test3", "=>", "test3"}], []}, [" "]]
    assert compile("asd %div{ test => test, test2 => test2,  test3 =>  test3 } test") == [["a"], ["s"], ["d"], [" "], {"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}, {"test3", "=>", "test3"}], []}, [" "], [" "], ["t"], ["e"], ["s"], ["t"]]
  end
  
end