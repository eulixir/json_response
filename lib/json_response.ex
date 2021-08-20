defmodule JsonResponse do
  use GenServer

  @empty_report %{total: 0, passed: 0, failed: 0}

  def init(_opts) do
    {:ok, %{passed: [], failed: []}}
  end

  def handle_cast({:suite_started, _opts}, config) do
    {:noreply, config}
  end

  def handle_cast({:suite_finished, %{async: _, load: _, run: _}}, config) do
    contents =
      config
      |> Map.new(fn {k, v} -> {k, format_tests(v)} end)
      |> Enum.reduce(@empty_report, fn {key, value}, acc -> handle_insert(acc, key, value) end)
      |> Jason.encode!(pretty: true)

    File.write!("results.json", contents)

    {:noreply, config}
  end

  def handle_cast({:suite_finished, _run_us, _load_us}, config) do
    contents =
      config
      |> Map.new(fn {k, v} -> {k, format_tests(v)} end)
      |> Jason.encode!(pretty: true)

    File.write!("results.json", contents)

    {:noreply, config}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: nil} = test}, config) do
    {:noreply, Map.update!(config, :passed, fn acc -> [test | acc] end)}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:failed, _failed}} = test}, config) do
    {:noreply, Map.update!(config, :failed, fn acc -> [test | acc] end)}
  end

  def handle_cast(_event, config), do: {:noreply, config}

  defp handle_insert(acc, key, value) do
    count = Enum.count(value)
    acc
    |> Map.put(key, count)
    |> Map.put(:total, acc.total + count)
    |> IO.inspect()
  end

  defp format_tests(tests) do
    Enum.map(tests, fn test ->
      Map.take(test.tags, [:file, :line, :module, :describe, :test])
    end)
  end
end
