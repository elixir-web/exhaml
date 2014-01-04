defmodule ExHaml.Utils do
  
  def is_next_is_symbol(<<c, _source_rest :: binary>>) do
    c > 32
  end

  def delete_last([]) do
    []
  end

  def delete_last(nil) do
    nil
  end

  def delete_last(list) do
    Enum.reverse(list) |> tl |> Enum.reverse
  end

end