defmodule LangSchema.Converter.OpenAITest do
  use ExUnit.Case, async: true
  alias LangSchema.Converter.OpenAI

  describe "to_json_schema" do
    test "returns wrapped json_schema with valid schema" do
      result =
        LangSchema.Test.Schema.schema()
        |> OpenAI.to_json_schema(
          ordered_properties: false,
          name: "test",
          description: "Test"
        )

      assert result == %{
               "name" => "test",
               "description" => "Test",
               "schema" => %{
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
                     "description" => "Email"
                   },
                   "role" => %{
                     "type" => ["string", "null"],
                     "description" => "Role",
                     "enum" => ["admin", "billing"]
                   },
                   "tags" => %{
                     "type" => "array",
                     "description" => "Tags",
                     "items" => %{"type" => "string", "description" => "Tag"}
                   },
                   "metadata" => %{
                     "type" => "object",
                     "description" => "Metadata",
                     "properties" => %{
                       "id" => %{"type" => "string"},
                       "extra" => %{"type" => "string"}
                     },
                     "additionalProperties" => false,
                     "required" => ["id", "extra"]
                   },
                   "null" => %{
                     "type" => "null",
                     "description" => "Null value"
                   }
                 },
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
                 ]
               },
               "strict" => true
             }
    end

    test "returns json_schema with keyword object schema with ordered_properties: true opt" do
      result =
        %{
          type: :object,
          properties: [
            test1: %{type: :string},
            test2: %{type: :string}
          ]
        }
        |> OpenAI.to_json_schema(ordered_properties: true)

      assert result["schema"]["properties"] == %Jason.OrderedObject{
               values: [
                 {"test1", %{"type" => "string"}},
                 {"test2", %{"type" => "string"}}
               ]
             }
    end

    test "raise error with map object schema with ordered_properties: true opt" do
      schema = %{
        type: :object,
        properties: %{
          test1: %{type: :string},
          test2: %{type: :string}
        }
      }

      assert_raise ArgumentError,
                   "Properties must be a keyword style(tuple with atom or string keys) when ordered_properties is true",
                   fn ->
                     schema |> OpenAI.to_json_schema(ordered_properties: true)
                   end
    end

    test "returns valid json_schema with any_of" do
      result =
        %{
          type: :object,
          properties: %{
            test: %{
              any_of: [
                %{type: :string},
                %{type: :integer}
              ]
            }
          }
        }
        |> OpenAI.to_json_schema()

      assert result["schema"]["properties"] == %{
               "test" => %{
                 "anyOf" => [
                   %{"type" => "string"},
                   %{"type" => "integer"}
                 ]
               }
             }
    end

    test "raise error with one_of" do
      schema = %{
        type: :object,
        properties: %{
          test: %{
            one_of: [%{type: :string}, %{type: :integer}]
          }
        }
      }

      assert_raise ArgumentError, ~r/Invalid combination :one_of/, fn ->
        schema |> OpenAI.to_json_schema()
      end
    end

    test "raise error with all_of" do
      schema = %{
        type: :object,
        properties: %{
          test: %{
            all_of: [%{type: :string}, %{type: :integer}]
          }
        }
      }

      assert_raise ArgumentError, ~r/Invalid combination :all_of/, fn ->
        schema |> OpenAI.to_json_schema()
      end
    end
  end

  describe "to_schema" do
    test "returns raw json schema without wrapping" do
      result = LangSchema.Test.Schema.schema() |> OpenAI.to_schema()

      assert %{"type" => "object", "description" => "All Types"} = result
      refute Map.has_key?(result, "name")
      refute Map.has_key?(result, "strict")
    end
  end
end
