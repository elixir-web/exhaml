defmodule Exhaml.Compiler do

  import ExHaml.Utils
    
  def compile(source) do
    tokenize(String.split(source, "/n"), [])
  end

  def tokenize([], buffer) do
    buffer
  end

  def tokenize([line | rest], buffer) do
    # parse line
    parsed_line = parse_line(line)
    # accumulate line
    #tokenize(rest, :lists.append(buffer, [parsed_line]))
  end

  def parse_line(line) do
    parse_line(line, [])
  end

  def parse_line(<<>>, buffer) do
    buffer
  end

  def parse_line(<<"!", "!", "!", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil -> 
        parse_line(source_rest, [[:doctype, :doctype_xhtml_transitional]])
      [:indentation] ->
        parse_line(source_rest, :lists.append(buffer, [[:doctype, :doctype_xhtml_transitional]]))
      [:doctype, _] ->
        parse_line(source_rest, :lists.append(buffer, [["!!!"]]))
      {_,_,_} ->
        parse_line(source_rest, :lists.append(buffer, [["!!!"]]))
      [str] ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[str <> "!!!"]]))
    end
  end

  def parse_line(<<" ", " ", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      [:comment] ->
        parse_line(source_rest, buffer)
      [:indentation] ->
        parse_line(source_rest, :lists.append(buffer, [[:indentation]]))
      [str] ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[str <> "  "]]))
      {tag, attr, opts} ->
        parse_line(source_rest, buffer)
      _ ->
        parse_line(source_rest, :lists.append(buffer, [[:indentation]]))
    end
  end

  def parse_line(<<" ", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil -> 
        parse_line(source_rest, buffer)
      [:doctype, _] ->
        parse_line(source_rest, buffer)
      [:comment] ->
        parse_line(source_rest, buffer)
      {tag, [], opts} ->
        parse_line(source_rest, :lists.append(buffer, [[" "]]))
      {tag, attr, opts} ->
        parse_line(source_rest, buffer)
      _ ->
        parse_line(source_rest, :lists.append(buffer, [[" "]]))
    end
  end

  @doc """
    "!!! Strict" handling
  """
  def parse_line(<<"S", "t", "r", "i", "c", "t", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        parse_line(source_rest, [["Strict"]])
      [:indentation] ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_xhtml_strict]]))
      [:doctype, _] ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_xhtml_strict]]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["Strict"]]))
    end
  end
  
  @doc """
    "!!! Frameset" handling
  """
  def parse_line(<<"F", "r", "r", "a", "m", "s", "e", "t", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        parse_line(source_rest, [["Frameset"]])
      [:doctype, _] ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_xhtml_frameset]]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["Frameset"]]))
    end
  end

  @doc """
    "5" symbol handling
  """
  def parse_line(<<"5", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        parse_line(source_rest, [["5"]])
      [:doctype, _] ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[:doctype, :doctype_html5]]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["5"]]))
    end
  end

  @doc """
    "-#" handling
  """
  def parse_line(<<"-", "#", source_rest :: binary>>, buffer) do
    parse_line(source_rest, :lists.append(buffer, [[:comment]]))
  end

  @doc """
   "%" handling
  """
  def parse_line(<<"%", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        parse_line(source_rest, :lists.append(buffer, [{}]))
      [:indentation] ->
        parse_line(source_rest, :lists.append(buffer, [{}]))
      [_] ->
        parse_line(source_rest, :lists.append(buffer, [{}]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["%"]]))
    end
  end

  @doc """
    "{" handling
  """
  def parse_line(<<"{", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      {tag, attr, opts} ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [{tag, [{"", "", ""}], []}]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["{"]]))
    end
  end

  @doc """
    "}" handling
  """
  def parse_line(<<"}", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      {tag, attr, opts} ->
        parse_line(source_rest, :lists.append(buffer, [[" "]]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["}"]]))
    end
  end

  @doc """
    "=>" handling
  """
  def parse_line(<<"=", ">", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        parse_line(source_rest, :lists.append(buffer, [["=>"]]))
      {tag, attr, opts} ->
        {key, bind, val} = List.last(attr)
        new_opts = :lists.append(delete_last(attr), [{key, "=>", val}])
        parse_line(source_rest, :lists.append(delete_last(buffer), [{tag, new_opts, opts}]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [["=>"]]))
    end
  end

  @doc """
    ',' hanlding
  """
  def  parse_line(<<",", source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      nil ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [[","]]))
      [:comment] ->
        parse_line(source_rest, buffer)
      {tag, [], opts} ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [{tag <> ",", [], opts}]))
      {tag, attr, opts} ->
        attr = :lists.append(attr, [{"", "", ""}])
        parse_line(source_rest, :lists.append(delete_last(buffer), [{tag, attr, opts}]))
      _ ->
        parse_line(source_rest, :lists.append(buffer, [[:erlang.list_to_binary([","])]]))   
    end
  end

  @doc """
    any symbol handling
  """
  def parse_line(<<symbol, source_rest :: binary>>, buffer) do
    case List.last(buffer) do
      [:comment] ->
        parse_line(source_rest, buffer)
      {} ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [{:erlang.list_to_binary([symbol]), [], []}]))
      {tag, [], opts} ->
        parse_line(source_rest, :lists.append(delete_last(buffer), [{tag <> :erlang.list_to_binary([symbol]), [], opts}]))
      {tag, attr, opts} ->
        case List.last(attr) do
          {key, "=>", val} ->
            attr = :lists.append(delete_last(attr), [{key, "=>", val <> :erlang.list_to_binary([symbol])}])
            parse_line(source_rest, :lists.append(delete_last(buffer), [{tag, attr, opts}]))
          {key, bind, val} -> 
            attr = :lists.append(delete_last(attr), [{key <> :erlang.list_to_binary([symbol]), bind, val}])
            parse_line(source_rest, :lists.append(delete_last(buffer), [{tag, attr, opts}]))
        end
      _ ->
        parse_line(source_rest, :lists.append(buffer, [[:erlang.list_to_binary([symbol])]]))
    end
  end

end