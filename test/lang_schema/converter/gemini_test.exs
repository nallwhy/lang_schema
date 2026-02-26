defmodule LangSchema.Converter.GeminiTest do
  use ExUnit.Case, async: true
  alias LangSchema.Converter.Gemini

  describe "to_schema" do
    test "returns json_schema with valid schema" do
      result = LangSchema.Test.Schema.schema() |> Gemini.to_schema(ordered_properties: false)

      assert result == %{
               "type" => "object",
               "description" => "All Types",
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
                   "format" => "email"
                 },
                 "role" => %{
                   "description" => "Role",
                   "enum" => ["admin", "billing"],
                   "nullable" => true,
                   "type" => "string"
                 },
                 "tags" => %{
                   "type" => "array",
                   "description" => "Tags",
                   "items" => %{"type" => "string", "description" => "Tag"},
                   "minItems" => 1,
                   "maxItems" => 5
                 },
                 "metadata" => %{
                   "type" => "object",
                   "description" => "Metadata",
                   "properties" => %{
                     "id" => %{"type" => "string"},
                     "extra" => %{"type" => "string"}
                   },
                   "required" => ["id"]
                 },
                 "null" => %{
                   "type" => "null",
                   "description" => "Null value"
                 }
               }
             }
    end
  end
end
