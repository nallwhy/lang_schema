defmodule LangSchemaTest do
  use ExUnit.Case, async: true

  describe "function_calling/3" do
    test "delegates to the correct converter for :openai" do
      schema = %{type: :string}
      result = LangSchema.function_calling(schema, :openai)

      assert result == %{"type" => "string"}
    end

    test "delegates to the correct converter for :google" do
      schema = %{type: :string}
      result = LangSchema.function_calling(schema, :google)

      assert result == %{"type" => "string"}
    end

    test "raises ArgumentError for invalid provider" do
      assert_raise ArgumentError, ~r/Invalid provider :unknown/, fn ->
        LangSchema.function_calling(%{type: :string}, :unknown)
      end
    end
  end

  describe "structured_output/3" do
    test "delegates to the correct converter for :openai" do
      schema = %{type: :string}
      result = LangSchema.structured_output(schema, :openai, name: "test")

      assert %{"name" => "test", "schema" => %{"type" => "string"}, "strict" => true} = result
    end

    test "delegates to the correct converter for :google" do
      schema = %{type: :string}
      result = LangSchema.structured_output(schema, :google)

      assert result == %{"type" => "string"}
    end

    test "raises ArgumentError for invalid provider" do
      assert_raise ArgumentError, ~r/Invalid provider :unknown/, fn ->
        LangSchema.structured_output(%{type: :string}, :unknown)
      end
    end
  end
end
