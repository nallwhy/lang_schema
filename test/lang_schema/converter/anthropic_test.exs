defmodule LangSchema.Converter.AnthropicTest do
  use ExUnit.Case, async: true
  alias LangSchema.Converter.Anthropic

  describe "function_calling" do
    test "returns json_schema with valid schema" do
      result =
        LangSchema.Test.Schema.schema() |> Anthropic.function_calling(ordered_properties: false)

      assert result == %{
               "type" => "object",
               "description" => "All Types",
               "additionalProperties" => false,
               "required" => [
                 "flag",
                 "rating",
                 "price",
                 "email",
                 "role",
                 "tags",
                 "metadata",
                 "null"
               ],
               "properties" => %{
                 "flag" => %{
                   "type" => "boolean",
                   "description" => "Flag"
                 },
                 "rating" => %{
                   "type" => "integer",
                   "description" => "Rating"
                 },
                 "price" => %{
                   "type" => "number",
                   "description" => "Price"
                 },
                 "email" => %{
                   "type" => "string",
                   "description" => "Email",
                   "format" => "email",
                   "pattern" =>
                     "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
                 },
                 "role" => %{
                   "type" => ["string", "null"],
                   "description" => "Role",
                   "enum" => ["admin", "billing"]
                 },
                 "tags" => %{
                   "type" => "array",
                   "description" => "Tags",
                   "items" => %{"type" => "string", "description" => "Tag"},
                   "minItems" => 1
                 },
                 "metadata" => %{
                   "type" => "object",
                   "description" => "Metadata",
                   "additionalProperties" => false,
                   "required" => ["id", "extra"],
                   "properties" => %{
                     "id" => %{"type" => "string"},
                     "extra" => %{"type" => "string"}
                   }
                 },
                 "null" => %{
                   "type" => "null",
                   "description" => "Null value"
                 }
               }
             }
    end
  end

  describe "structured_output" do
    test "returns raw json_schema (LangChain wraps it into output_config.format.schema)" do
      result = %{type: :string} |> Anthropic.structured_output()

      assert result == %{"type" => "string"}
    end
  end
end
