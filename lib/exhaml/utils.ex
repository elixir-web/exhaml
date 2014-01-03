defmodule ExHaml.Utils do
  
  def is_next_is_symbol(<<c, _source_rest :: binary>>) do
    c > 32
  end

end