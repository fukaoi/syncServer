defmodule SyncServer do
  require Logger

  def start_link do
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  def add_word(word) do
    Agent.update(
      __MODULE__,
      fn dict ->
        IO.inspect dict
        Map.update(dict, word, 1, &(&1 + 1))
      end)
  end

  def count_for(word) do
    Agent.get(__MODULE__, &Map.get(&1, word))
  end

  def words do
    IO.inspect __MODULE__
    Agent.get(__MODULE__, &(Map.keys(&1)))
  end
end
