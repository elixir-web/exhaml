defmodule ExhamlTest do
  use ExUnit.Case

  import Exhaml.Compiler

  test "the truth" do
    assert(true)
  end

  #test "Exhaml doctype test" do
  #  assert parse_line("!!! Strict  ", []) == [[:doctype, :doctype_xhtml_strict], [:indentation]]
  #  assert parse_line("  !!! Strict", []) == [[:indentation], [:doctype, :doctype_xhtml_strict]]
  #  assert parse_line("!!! 5  ", []) == [[:doctype, :doctype_html5], [:indentation]]
  #  assert parse_line("!!! 5  -#  asdsfg", []) == [[:doctype, :doctype_html5], [:indentation], [:comment]]
  #  assert parse_line("!!! 5  -#    asdsfg", []) == [[:doctype, :doctype_html5], [:indentation], [:comment]]
  #  assert parse_line("!!! 5   -# asdsfg", []) == [[:doctype, :doctype_html5], [:indentation], [" "], [:comment]]
  #end

  #test "Exhaml tag test" do
  #  assert parse_line("%p", []) == [{"p", [], []}]
  #  assert parse_line("%div", []) == [{"div", [], []}]
  #  assert parse_line("%div ", []) == [{"div", [], []}, [" "]]
  #  assert parse_line("%div  ", []) == [{"div", [], []}]
  #  assert parse_line("%div   ", []) == [{"div", [], []}, [" "]]
  #  assert parse_line(" %div   ", []) == [{"div", [], []}, [" "]]
  #  assert parse_line("  %div", []) ==  [[:indentation], {"div", [], []}]
  #  assert parse_line("  %div", []) ==  [[:indentation], {"div", [], []}]
  #  assert parse_line("  %div  ", []) ==  [[:indentation], {"div", [], []}]
  #  assert parse_line("    %div  ", []) ==  [[:indentation], [:indentation], {"div", [], []}]
  #  assert parse_line("     %div  ", []) ==  [[:indentation], [:indentation], [" "], {"div", [], []}]     
  #end

  #test "Parse text" do
  #  assert parse_line("test", []) == [["t"], ["e"], ["s"], ["t"]]
  #  assert parse_line("  test", []) == [[:indentation], ["t"], ["e"], ["s"], ["t"]]
  #  assert parse_line("   test", []) == [[:indentation], [" "], ["t"], ["e"], ["s"], ["t"]]
  #  assert parse_line("   test ", []) == [[:indentation], [" "], ["t"], ["e"], ["s"], ["t"], [" "]]
  #  assert parse_line("   test  ", []) == [[:indentation], [" "], ["t"], ["e"], ["s"], ["t  "]]
  #  assert parse_line("  %div test  ", []) == [[:indentation], {"div", [], []}, [" "], ["t"], ["e"], ["s"], ["t  "]] 
  #end

  #test "Parse tag with attributes" do
  #  assert parse_line("%div{test=>test}", []) == [{"div", [{"test", "=>", "test"}], []}, [" "]]
  #  assert parse_line("  %div{test=>test}", []) == [[:indentation], {"div", [{"test", "=>", "test"}], []}, [" "]]
  #  assert parse_line("   %div{ test=>test}", []) == [[:indentation], [" "], {"div", [{"test", "=>", "test"}], []}, [" "]]
  #  assert parse_line("%div{  test=>test}", []) == [{"div", [{"test", "=>", "test"}], []}, [" "]]
  #  assert parse_line("%div{  test=>test   }", []) == [{"div", [{"test", "=>", "test"}], []}, [" "]]
  #  assert parse_line("%div{ test => test, test2 => test2 }", []) == [{"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}], []}, [" "]]
  #  assert parse_line("%div{ test => test, test2 => test2,  test3 =>  test3 }", []) == [{"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}, {"test3", "=>", "test3"}], []}, [" "]]
  #  assert parse_line("asd %div{ test => test, test2 => test2,  test3 =>  test3 } test", []) == [["a"], ["s"], ["d"], [" "], {"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}, {"test3", "=>", "test3"}], []}, [" "], [" "], ["t"], ["e"], ["s"], ["t"]]
  #end

  def test1 do
    """
    %section
      %h1
        %h2
    """
  end

  def test2 do
    """
    %section
      %h1
        %div{ test => test, test2 => test2}
        asd
    %div
    """
  end

  def test3 do
    """
    %ul
      %li
        %a{:href => "#devices-tab"}Devices
      %li
        %a{:href => "#options-tab"}System Options
      %li
        %a{:href => "#reports-tab"}Reports
      %li
        %a{:href => "#notes-tab"}Notes
    """
  end

  def test4 do
    """
    %div{ class => main }
      %div{class = int1 }
      %div{class = int2, id = int22 }
    """
  end

  test "1" do
    assert compile(test1) == [[{"section", [], []}], [[:indentation], {"h1", [], []}], [[:indentation], [:indentation], {"h2", [], []}], []]
    assert compile(test2) == [[{"section", [], []}], [[:indentation], {"h1", [], []}], [[:indentation], [:indentation], {"div", [{"test", "=>", "test"}, {"test2", "=>", "test2"}], []}, [" "]], [[:indentation], [:indentation], ["a"], ["s"], ["d"]], [{"div", [], []}], []]
    assert compile(test3) == [[{"ul", [], []}], [[:indentation], {"li", [], []}], [[:indentation], [:indentation], {"a", [{":href", "=>", "\"#devices-tab\""}], []}, [" "], ["D"], ["e"], ["v"], ["i"], ["c"], ["e"], ["s"]], [[:indentation], {"li", [], []}], [[:indentation], [:indentation], {"a", [{":href", "=>", "\"#options-tab\""}], []}, [" "], ["S"], ["y"], ["s"], ["t"], ["e"], ["m"], [" "], ["O"], ["p"], ["t"], ["i"], ["o"], ["n"], ["s"]], [[:indentation], {"li", [], []}], [[:indentation], [:indentation], {"a", [{":href", "=>", "\"#reports-tab\""}], []}, [" "], ["R"], ["e"], ["p"], ["o"], ["r"], ["t"], ["s"]], [[:indentation], {"li", [], []}], [[:indentation], [:indentation], {"a", [{":href", "=>", "\"#notes-tab\""}], []}, [" "], ["N"], ["o"], ["t"], ["e"], ["s"]], []]
    assert compile(test4) == [[{"div", [{"class", "=>", "main"}], []}, [" "]], [[:indentation], {"div", [{"class=int1", "", ""}], []}, [" "]], [[:indentation], {"div", [{"class=int2", "", ""}, {"id=int22", "", ""}], []}, [" "]], []]
  end
  
end