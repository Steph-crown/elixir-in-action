defmodule B do
  def empty?([]), do: true
  def empty?([_ | _]), do: false

  # def fact(0), do: 1

  def fact(0), do: 1

  def fact(n) do
    n * fact(n - 1)
  end

  def sum([]), do: 0

  def sum([h | t]) do
    h + sum(t)
  end

  def print(1), do: IO.puts(1)

  def print(n) when n > 1 do
    print(n - 1)
    IO.puts(n)
  end

  # list_len
  def l([]), do: 0

  def l([_ | t]), do: l(t) + 1

  # range
  def r(f, f), do: [f]
  def r(f, t), do: [f | r(f + 1, t)]

  # returns positiive lists
  def p([]), do: []

  def p([h | t]) when h > 0 do
    [h | p(t)]
  end

  def p([_ | t]), do: p(t)

  #  The following example takes the input list and prints the square root of only those elements that represent a non-negative number, adding an indexed prefix at the beginning:
  def sq(l) do
    l
    # |> Stream.filter(fn x -> is_number(x) && x >= 0 end)
    |> Stream.filter(&(is_number(&1) && &1 >= 0))
    |> Stream.with_index()
    |> Enum.each(fn {x, i} -> IO.puts("#{i + 1}. sqrt(#{x}) = #{x * x}") end)
  end

  def large_lines!(path) do
    File.stream!(path)
    # |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(& &1)
  end

  def lines_length(path) do
    File.stream!(path)
    |> Enum.map(&String.length/1)
  end

  def longest_line_length!(path) do
    path
    |> lines_length()
    |> Enum.max()
  end

  def longest_line!(path) do
    File.stream!(path)
    |> Enum.max_by(&String.length/1)
  end

  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(&length(String.split(&1)))
    |> Enum.map(& &1)
  end
end
