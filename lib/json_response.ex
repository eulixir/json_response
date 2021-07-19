defmodule JsonFormatter do
  use GenServer

  def init(_opts) do
    {:ok, %{passed: [], skiped: [], excluded: [], failed: [], invalid: []}}
  end

  def handle_cast({:suite_started, _opts}, config) do
    {:noreply, config}
  end

  def handle_cast({:suite_finished, %{async: _, load: _, run: _}}, config) do
    contents =
      config
      |> Map.new(fn {k, v} -> {k, format_tests(v)} end)
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

  def handle_cast({:test_finished, %ExUnit.Test{state: {:skip, _}} = test}, config) do
    {:noreply, Map.update!(config, :skiped, fn acc -> [test | acc] end)}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:excluded, _}} = test}, config) do
    {:noreply, Map.update!(config, :excluded, fn acc -> [test | acc] end)}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:failed, _failed}} = test}, config) do
    {:noreply, Map.update!(config, :failed, fn acc -> [test | acc] end)}
  end

  def handle_cast({:test_finished, %ExUnit.Test{state: {:invalid, _module}} = test}, config) do
    {:noreply, Map.update!(config, :invalid, fn acc -> [test | acc] end)}
  end

  def handle_cast(_event, config), do: {:noreply, config}

  defp format_tests(tests) do
    Enum.map(tests, fn test ->
      Map.take(test.tags, [:file, :line, :module, :describe, :test])
    end)
  end
end
