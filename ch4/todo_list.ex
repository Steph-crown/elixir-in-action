defmodule TodoList do
  # entries %{id: entry = %{date, title}}
  defstruct auto_id: 1, entries: %{}

  def new(
        auto_id \\ 1,
        entries \\ %{}
      ),
      do: %TodoList{auto_id: auto_id, entries: entries}

  def from_list(entries \\ []), do: do_from_list(entries, new())

  def do_from_list([], %TodoList{} = todo_list), do: todo_list

  def do_from_list([h | t], %TodoList{} = todo_list) do
    todo_list = add_entry(todo_list, h)
    do_from_list(t, todo_list)
  end

  def alt_from_list(entries \\ []) do
    Enum.reduce(
      entries,
      new(),
      &add_entry(&2, &1)
    )
  end

  def add_entry(
        %TodoList{
          auto_id: auto_id,
          entries: entries
        },
        entry
      ) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)

    new(auto_id + 1, new_entries)
  end

  def entries(
        %TodoList{
          entries: entries
        },
        date
      ) do
    # MultiDict.get(todo_list, date)
    entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def due_today(%TodoList{} = todo_list) do
    today = Date.utc_today()
    entries(todo_list, today)
  end

  def update_entry(
        %TodoList{
          entries: entries,
          auto_id: auto_id
        } = todo_list,
        id,
        new_entry
      ) do
    case Map.fetch(entries, id) do
      {:ok, _} ->
        entries = Map.put(entries, id, new_entry)
        new(auto_id, entries)

      :error ->
        todo_list
    end
  end

  def delete_entry(
        %TodoList{
          entries: entries,
          auto_id: auto_id
        } = todo_list,
        id
      ) do
    case Map.fetch(entries, id) do
      {:ok, _} ->
        entries = Map.delete(entries, id)
        new(auto_id, entries)

      :error ->
        todo_list
    end
  end
end

defmodule MultiDict do
  def new, do: %{}

  def add(dict, key, value) do
    Map.update(dict, key, [value], &[value | &1])
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end

defmodule Fraction do
  defstruct h: nil, t: nil

  def new(h, t), do: %Fraction{h: h, t: t}

  def add(%Fraction{h: h1, t: t1}, %Fraction{h: h2, t: t2}) do
    h = h1 * t2 + h2 * t1
    t = t1 * t2

    new(h, t)
  end

  def subtract(%Fraction{h: h1, t: t1}, %Fraction{h: h2, t: t2}) do
    h = h1 * t2 - h2 * t1
    t = t1 * t2

    new(h, t)
  end

  def to_string(%Fraction{h: h, t: t}) do
    "#{h}/#{t}"
  end

  def value(%Fraction{h: h, t: t}) do
    h / t
  end

  def is_fraction(%Fraction{}), do: true
  def is_fraction(_), do: false
end

defmodule TodoList.CsvImporter do
  def import(path) do
    File.stream!(path)
    |> Stream.map(&String.split(&1, ","))
    |> Enum.map(fn [date, title] ->
      %{
        date: date,
        title: String.replace(title, "\n", "")
      }
    end)
    |> TodoList.from_list()
  end
end

# defprotocol String.Chars do
#   def to_string(thing)
# end

defimpl String.Chars, for: TodoList do
  def to_string(%TodoList{auto_id: auto_id}) do
    "%TodoList{} length #{auto_id - 1}"
  end
end

defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end

defimpl Size, for: BitString do
  def size(binary), do: byte_size(binary)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end
