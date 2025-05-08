if Code.ensure_loaded?(LangChain.FunctionParam) do
  defmodule LangSchema.Adapter.LangChainFunctionParam do
    use LangSchema.Adapter
    alias LangSchema.Util.Nillable

    @impl LangSchema.Adapter
    def to_schema(function_params) when is_list(function_params) do
      %{
        type: :object,
        properties: do_to_schema(function_params),
        required: required(function_params)
      }
    end

    # object_properties
    defp do_to_schema(function_params) when is_list(function_params) do
      function_params
      |> Enum.map(fn %LangChain.FunctionParam{name: name} = function_param ->
        {name, do_to_schema(function_param)}
      end)
    end

    defp do_to_schema(%LangChain.FunctionParam{type: :object} = function_param) do
      %{
        type: function_param.type,
        properties: do_to_schema(function_param.object_properties),
        required: required(function_param.object_properties)
      }
      |> maybe_put_description(function_param)
    end

    defp do_to_schema(%LangChain.FunctionParam{type: :array} = function_param) do
      items =
        %{
          type: function_param.item_type |> String.to_existing_atom()
        }
        |> then(fn items ->
          case function_param.item_type do
            "object" ->
              items
              |> Map.merge(%{
                properties: do_to_schema(function_param.object_properties),
                required: required(function_param.object_properties)
              })

            _ ->
              items
          end
        end)

      %{
        type: function_param.type,
        items: items
      }
      |> maybe_put_description(function_param)
    end

    defp do_to_schema(%LangChain.FunctionParam{} = function_param) do
      %{
        type: function_param.type
      }
      |> maybe_put_description(function_param)
      |> maybe_put_enum(function_param)
    end

    defp maybe_put_description(schema, %LangChain.FunctionParam{description: description}) do
      Nillable.run_if(schema, description, fn schema ->
        schema |> Map.put(:description, description)
      end)
    end

    defp maybe_put_enum(schema, %LangChain.FunctionParam{enum: enum}) do
      case enum do
        [_ | _] -> schema |> Map.put(:enum, enum)
        _ -> schema
      end
    end

    defp required(function_params) do
      function_params
      |> Enum.filter(fn %LangChain.FunctionParam{required: required} -> required end)
      |> Enum.map(fn %LangChain.FunctionParam{name: name} -> name end)
    end
  end
end
