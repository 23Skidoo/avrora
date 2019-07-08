defmodule Avrora.MemoryStorageTest do
  use ExUnit.Case, async: true
  doctest Avrora.MemoryStorage

  alias Avrora.MemoryStorage

  setup do
    pid = start_supervised!({MemoryStorage, name: :test_schema_storage})

    %{schema_storage: pid}
  end

  describe "put/3" do
    test "when key is new", %{schema_storage: pid} do
      assert get(pid, "my-key") == {:ok, nil}
      assert put(pid, "my-key", schema()) == {:ok, schema()}
      assert get(pid, "my-key") == {:ok, schema()}
    end

    test "when key already exists", %{schema_storage: pid} do
      {:ok, _} = put(pid, "my-key", schema())

      assert get(pid, "my-key") == {:ok, schema()}
      assert put(pid, "my-key", new_schema()) == {:ok, new_schema()}
      assert get(pid, "my-key") == {:ok, new_schema()}
    end
  end

  describe "get/2" do
    test "when key already exists", %{schema_storage: pid} do
      {:ok, _} = put(pid, "my-key", schema())

      assert get(pid, "my-key") == {:ok, schema()}
    end

    test "when key does not exist", %{schema_storage: pid} do
      assert get(pid, "my-key") == {:ok, nil}
    end
  end

  defp get(pid, key), do: MemoryStorage.get(pid, key)
  defp put(pid, key, value), do: MemoryStorage.put(pid, key, value)

  defp schema,
    do: %Avrora.Schema{id: 1, schema: %AvroEx.Schema{}, raw_schema: %{"hello" => "world"}}

  defp new_schema,
    do: %Avrora.Schema{id: 1, schema: %AvroEx.Schema{}, raw_schema: %{"one" => "two"}}
end