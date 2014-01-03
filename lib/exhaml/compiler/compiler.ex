defmodule Exhaml.Compiler do

  import ExHaml.Utils
    
  def compile(source) do
    tokens = tokenize(source, [])
  end

  @doc """
    '%' handling
  """
  def tokenize(<<37, source_rest :: binary>>, buffer) do
    case is_next_is_symbol(source_rest) do
        true ->
            # create new tag
            tokenize(source_rest, :lists.append([{}], buffer))
        false ->
            # plain text
            tokenize(source_rest, :lists.append([{}], buffer))
    end
  end

  def tokenize(_, _) do
    :mock
  end

end