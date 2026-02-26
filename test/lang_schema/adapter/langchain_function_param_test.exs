defmodule LangSchema.Adapter.LangChainFunctionParamTest do
  use ExUnit.Case, async: true
  alias LangSchema.Adapter.LangChainFunctionParam

  setup do
    function_params = [
      LangChain.FunctionParam.new!(%{
        name: "person",
        type: :object,
        required: true,
        object_properties: [
          LangChain.FunctionParam.new!(%{name: "name", type: :string, required: true}),
          LangChain.FunctionParam.new!(%{name: "age", type: :integer})
        ]
      }),
      LangChain.FunctionParam.new!(%{
        name: "tags",
        type: :array,
        item_type: "string"
      })
    ]

    %{function_params: function_params}
  end

  test "to_schema", %{function_params: function_params} do
    assert LangChainFunctionParam.to_schema(function_params) == %{
             type: :object,
             properties: [
               {"person",
                %{
                  type: :object,
                  properties: [
                    {"name", %{type: :string}},
                    {"age", %{type: :integer}}
                  ],
                  required: ["name"]
                }},
               {"tags",
                %{
                  type: :array,
                  items: %{type: :string}
                }}
             ],
             required: ["person"]
           }
  end

  test "convert", %{function_params: function_params} do
    assert LangChainFunctionParam.convert(function_params, LangSchema.Converter.OpenAI) == %{
             "type" => "object",
             "properties" => %{
               "person" => %{
                 "type" => "object",
                 "properties" => %{
                   "name" => %{"type" => "string"},
                   "age" => %{"type" => "integer"}
                 },
                 "required" => ["name", "age"],
                 "additionalProperties" => false
               },
               "tags" => %{
                 "type" => "array",
                 "items" => %{"type" => "string"}
               }
             },
             "required" => ["person", "tags"],
             "additionalProperties" => false
           }
  end
end
