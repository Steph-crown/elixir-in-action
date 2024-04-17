defmodule Calculator do
  def start do
    state_value = 0
    spawn(fn -> loop(state_value) end)
  end

  def loop(state_value) do
    state_value =
      receive do
        message ->
          process_message(state_value, message)
      end

    loop(state_value)
  end

  defp process_message(state_value, {:add, value}), do: state_value + value
  defp process_message(state_value, {:sub, value}), do: state_value - value
  defp process_message(state_value, {:mul, value}), do: state_value * value
  defp process_message(state_value, {:div, value}), do: state_value / value

  defp process_message(state_value, {:value, caller}) do
    send(caller, {:value, state_value})
    state_value
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})

    receive do
      {:value, state_value} ->
        state_value
    after
      5000 -> {:error, :timeout}
    end
  end

  def add(server_pid, value) do
    send(server_pid, {:add, value})
  end

  def sub(server_pid, value) do
    send(server_pid, {:sub, value})
  end

  def mul(server_pid, value) do
    send(server_pid, {:mul, value})
  end

  def div(server_pid, value) do
    send(server_pid, {:div, value})
  end
end
