defmodule JsonResponseTest do
  use ExUnit.Case
  doctest JsonResponse

  test "greets the world" do
    assert JsonResponse.hello() == :world
  end
end
