defmodule LangSchemaTest do
  use ExUnit.Case, async: true

  describe "to_schema/3" do
    test "delegates to the correct converter for :openai" do
      schema = %{type: :string}
      result = LangSchema.to_schema(schema, :openai)

      assert result == %{"type" => "string"}
    end

    test "delegates to the correct converter for :gemini" do
      schema = %{type: :string}
      result = LangSchema.to_schema(schema, :gemini)

      assert result == %{"type" => "string"}
    end

    test "raises ArgumentError for invalid provider" do
      assert_raise ArgumentError, ~r/Invalid provider :unknown/, fn ->
        LangSchema.to_schema(%{type: :string}, :unknown)
      end
    end
  end

  describe "to_json_schema/3" do
    test "delegates to the correct converter for :openai" do
      schema = %{type: :string}
      result = LangSchema.to_json_schema(schema, :openai, name: "test")

      assert %{"name" => "test", "schema" => %{"type" => "string"}, "strict" => true} = result
    end

    test "delegates to the correct converter for :gemini" do
      schema = %{type: :string}
      result = LangSchema.to_json_schema(schema, :gemini)

      assert result == %{"type" => "string"}
    end

    test "raises ArgumentError for invalid provider" do
      assert_raise ArgumentError, ~r/Invalid provider :unknown/, fn ->
        LangSchema.to_json_schema(%{type: :string}, :unknown)
      end
    end
  end
end
