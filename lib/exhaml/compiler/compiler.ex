defmodule Exhaml.Compiler do

  import ExHaml.Utils
    
  def compile(source) do
    tokenize(source, [])
  end

  @todo """
    1. Check spaces when after [{_,_,_}] ussual string.
  """

  @doc """
    The end of tokenizer
  """
  def tokenize(<<>>, buffer) do
    buffer
  end

  @doc """
    '/n' handling
  """
  def tokenize(<<10, source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil -> 
        tokenize(source_rest, [["/n"]])
      [:doctype, _] -> 
        tokenize(source_rest, buffer)
      [{_, _, _}] ->
         tokenize(source_rest, buffer)
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> "/n"]]))
    end
  end

  @doc """
    '/t' handling
  """
  def tokenize(<<9, source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil -> 
        tokenize(source_rest, [["/t"]])
      [:doctype, _] -> 
        tokenize(source_rest, buffer)
      [{_, _, _}] ->
         tokenize(source_rest, buffer)
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> "/t"]]))
    end
  end

  @doc """
    'space' handling
  """
  def tokenize(<<32, source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil -> 
        tokenize(source_rest, [[" "]])
      [:doctype, _] -> 
        tokenize(source_rest, buffer)
      [{_, _, _}] ->
         tokenize(source_rest, buffer)
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> " "]]))
    end
  end

  @doc """
    '!!!' handling
  """
  def tokenize(<<33, 33, 33, source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil -> 
        tokenize(source_rest, [[:doctype, :doctype_xhtml_transitional]])
      [:doctype, _] ->
        tokenize(source_rest, :lists.append(buffer, [["!!!"]]))
      [{_,_,_}] ->
        tokenize(source_rest, :lists.append(buffer, [["!!!"]]))
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> " "]]))
    end
  end

  @doc """
    '!!! Strict' handling
  """
  def tokenize(<<'S', 't', 'r', 'i', 'c', 't', source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        tokenize(source_rest, [["Strict"]])
      [:doctype, _] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_xhtml_strict]]))
      [{_, _, _}] ->
        tokenize(source_rest, :lists.append(buffer, [["Strict"]]))
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> "Strict"]]))
    end
  end
  
  @doc """
    '!!! Frameset' handling
  """
  def tokenize(<<'F', 'r', 'r', 'a', 'm', 's', 'e', 't', source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        tokenize(source_rest, [["Frameset"]])
      [:doctype, _] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_xhtml_frameset]]))
      [{_, _, _}] ->
        tokenize(source_rest, :lists.append(buffer, [["Frameset"]]))
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> "Frameset"]]))
    end
  end

  @doc """
    '!!! 5' handling
  """
  def tokenize(<<'5', source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        tokenize(source_rest, [["5"]])
      [:doctype, _] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_html5]]))
      [{_, _, _}] ->
        tokenize(source_rest, :lists.append(buffer, [["5"]]))
      [str] ->
        tokenize(source_rest, :lists.append(delete_last(buffer), [[str <> "5"]]))
    end
  end
  
  @doc """
    -# handling
  """
  def tokenize(<<'-', '#', source_rest :: binary>>, buffer) do

  end

  @doc """
    '%' handling
  """
  #def tokenize(<<37, source_rest :: binary>>, buffer) do
  #  case is_next_is_symbol(source_rest) do
  #      true ->
  #          # create new tag
  #          tokenize(source_rest, :lists.append([{}], buffer))
  #      false ->
  #          # plain text
  #          tokenize(source_rest, :lists.append([{}], buffer))
  #  end
  #end

end