defmodule Geometry do
  require Logger

  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:square, a}) do
    a * 3
  end

  def area({:circle, r}) do
    r * r * 3.14
  end

  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n), do: fibonacci(n - 1) + fibonacci(n - 2)

  def fact(0), do: 1
  def fact(n), do: n * fact(n - 1)

  def sum(list, current_sum \\ 0)
  def sum([], current_sum), do: current_sum
  def sum([h | t], current_sum), do: sum(t, h + current_sum)

  def list_length(list) do
    do_list_length(list, 0)
  end

  def do_list_length(list, count \\ 0)
  def do_list_length([], count), do: count
  def do_list_length([h | t], count), do: do_list_length(t, count + 1)

  def range(from, to) do
    do_range(from, to, to)
  end

  def do_range(from, to, current_index, list \\ [])
  def do_range(from, to, from, list), do: [from | list]

  def do_range(from, to, current_index, list),
    do: do_range(from, to, current_index - 1, [current_index | list])

  def positive(list, list_of_positives \\ [])
  def positive([], list_of_positives), do: Enum.reverse(list_of_positives)

  def positive([h | t], list_of_positives) do
    if h > 0 do
      positive(t, [h | list_of_positives])
    else
      positive(t, list_of_positives)
    end
  end

  def print(1), do: IO.puts(1)

  def print(n) when is_integer(n) and n > 0 do
    print(n - 1)
    IO.puts(n)
  end

  def num_with_sign(_) do
    Logger.error("jsj")
    3
  end

  def print(_), do: IO.inspect({:error, "Invalid arg"})

  def percentage(num, base), do: num / base * 100
  def percentage(num, base, dp: dp), do: "sadj"

  def from_ms(ms) do
    hrs = ms |> from_ms(:hrs) |> trunc
    mins = ms |> from_ms(:mins) |> trunc
    rem_mins = mins - hrs * 60
    secs = ms |> from_ms(:secs) |> trunc
    rem_secs = secs - rem_mins * 60 - hrs * 3_600
    # mins = ms |> from_ms(:hrs) |> trunc - hours * 60
    # secs = div(ms, 1000) - mins * 60 - hours * 60 * 60
    rem_ms = ms - rem_secs * 1000 - rem_mins * 60_000 - hrs * 3_600_000

    [hrs, rem_mins, rem_secs]
  end

  def from_ms(ms, :secs, trunc: trunc) do
    IO.inspect("trunc", trunc)
    ms / 1000
  end

  def from_ms(ms, :mins) do
    ms / 60_000
  end

  def from_ms(ms, :hrs) do
    ms / 3_600_000
  end

  def ms_to_str(ms) do
    [hrs, rem_mins, rem_secs] = from_ms(ms)

    cond do
      hrs > 0 -> "#{hrs} hrs, #{rem_mins} mins, #{rem_secs} secs"
      rem_mins > 0 -> "#{rem_mins} mins, #{rem_secs} secs"
      true -> "#{rem_secs} secs"
    end
  end

  def trade_type(true), do: "call"
  def trade_type(false), do: "put"
  def trade_type(_), do: ""

  def sec_to_hms_str(secs) do
    {hrs, mins, secs} = sec_to_hms_tuple(secs)

    cond do
      hrs > 0 -> "#{hrs} hrs, #{mins} mins, #{secs} secs"
      mins > 0 -> "#{mins} mins, #{secs} secs"
      true -> "#{secs} secs"
    end
  end

  def sec_to_hms_tuple(secs) do
    {hrs, rem} = divmod(secs, 3600)
    {mins, secs} = divmod(rem, 60)

    {hrs, mins, secs}
  end

  def convert_secs(secs, :mins), do: secs / 60
  def convert_secs(secs, :hrs), do: secs / 3600

  def divmod(num, divisor) do
    result = num / divisor
    quot = floor(result)
    rem = num - quot * divisor
    {quot, rem}
  end
end

IO.puts(Geometry.num_with_sign(-599) + 9)
