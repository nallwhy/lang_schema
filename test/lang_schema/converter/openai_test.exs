defmodule LangSchema.Converter.OpenAITest do
  use ExUnit.Case, async: true
  alias LangSchema.Converter.OpenAI

  describe "convert" do
    test "returns wraped json_schema with valid schema" do
      result =
        LangSchema.Test.Schema.schema()
        |> OpenAI.convert(
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
                     "required" => ["extra", "id"]
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
                   "metadata"
                 ]
               },
               "strict" => true
             }
    end

    test "returns not wraped json_schema with wrap?: false opt" do
      result = LangSchema.Test.Schema.schema() |> OpenAI.convert(wrap?: false)

      assert %{"type" => "object", "description" => "All Types"} = result
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
        |> OpenAI.convert(ordered_properties: true)

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
                   ~r/Properties must be a keyword list when ordered_properties is true/,
                   fn ->
                     schema |> OpenAI.convert(ordered_properties: true)
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
        |> OpenAI.convert()

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
        schema |> OpenAI.convert()
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
        schema |> OpenAI.convert()
      end
    end
  end
end
