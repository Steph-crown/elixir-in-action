defmodule TypeSpecs do
  @moduledoc """
  This feature allows you to provide type information for your functions, which can later be analyzed with a static analysis tool called dialyzer (http://erlang.org/ doc/man/dialyzer.html).
  """

  @spec add(integer, integer) :: integer
  def add(a, b) do
    a + b
  end

  def fn_with_opts(a, b, opts \\ []) do
    c = Keyword.get(opts, :c, 0)

    IO.puts(c)
  end

  IO.puts(TypeSpecs.add(21, 3))

  # IO.puts(new_func)
end
