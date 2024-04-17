defmodule TodoServer do
  def start do
    todo_list = TodoList.new()

    spawn(fn -> loop(todo_list) end)
  end

  defp loop(todo_list) do
    todo_list =
      receive do
        message ->
          process_message(todo_list, message)
      end

    loop(todo_list)
  end

  defp process_message(todo_list, {:add_entry, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp process_message(todo_list, {:entries, date, caller}) do
    entries = TodoList.entries(todo_list, date)
    send(caller, {:entries, entries})

    todo_list
  end

  def add_entry(server_pid, entry) do
    send(server_pid, {:add_entry, entry})
  end

  def entries(server_pid, date) do
    send(server_pid, {:entries, date, self()})

    receive do
      {:entries, entries} ->
        entries
    after
      5000 ->
        {:error, :timeout}
    end
  end
end

# TodoServer where the pid is registered in the process.
defmodule RegisteredTodoServer do
  def start do
    todo_list = TodoList.new()

    pid = spawn(fn -> loop(todo_list) end)
    Process.register(pid, :todo_server)

    pid
  end

  defp loop(todo_list) do
    todo_list =
      receive do
        message ->
          process_message(todo_list, message)
      end

    loop(todo_list)
  end

  defp process_message(todo_list, {:add_entry, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp process_message(todo_list, {:entries, date, caller}) do
    entries = TodoList.entries(todo_list, date)
    send(caller, {:entries, entries})

    todo_list
  end

  def add_entry(entry) do
    send(:todo_server, {:add_entry, entry})
  end

  def entries(date) do
    send(:todo_server, {:entries, date, self()})

    receive do
      {:entries, entries} ->
        entries
    after
      5000 ->
        {:error, :timeout}
    end
  end
end

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
