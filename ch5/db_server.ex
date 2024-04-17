defmodule DbServer do
  def start do
    query_counter = 1
    spawn(fn -> loop(query_counter) end)
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  defp loop(query_counter) do
    query_counter =
      receive do
        {:run_query, caller, query_def} ->
          send(caller, {:query_result, run_query("#{query_def} count #{query_counter}")})
          query_counter + 1
      end

    loop(query_counter)
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5000 -> {:error, :timeout}
    end
  end

  defp run_query(query_def) do
    Process.sleep(2000)
    "#{query_def} result"
  end
end
