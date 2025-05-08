defmodule LangSchema.Type.Gemini.Object do
  use LangSchema.Type
  alias LangSchema.Util.Nillable
  alias LangSchema.Util.KeywordStyle

  @impl LangSchema.Type
  def convert(%{properties: properties} = schema, converter_mod, opts) do
    json_schema = LangSchema.Type.Object.convert(schema, converter_mod, opts)

    property_ordering =
      case opts |> Keyword.get(:ordered_properties, false) do
        true ->
          case schema |> Map.get(:property_ordering) do
            property_ordering when is_list(property_ordering) ->
              property_ordering

            nil ->
              if not KeywordStyle.keyword_style?(properties) do
                raise ArgumentError,
                      "Properties must be a keyword style(tuple with atom or string keys) when ordered_properties is true and property_ordering is not set"
              end

              properties |> KeywordStyle.keys()
          end

        false ->
          nil
      end

    json_schema
    |> Nillable.run_if(property_ordering, fn json_schema ->
      json_schema |> Map.put("propertyOrdering", property_ordering)
    end)
  end

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:required]
  end
end
