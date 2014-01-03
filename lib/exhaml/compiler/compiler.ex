defmodule Exhaml.Compiler do
    
  def compile(source) do
    tokens = tokenize(source, [])
  end

  #
  # [{tag, attributes, [tags]}]
  #


  @doc """
    '%' handling
  """
  def tokenize(<<37, source_rest :: binary>>, buffer) do
    
  end

end