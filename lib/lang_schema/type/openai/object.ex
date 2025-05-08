defmodule LangSchema.Type.OpenAI.Object do
  use LangSchema.Type
  alias LangSchema.Util.KeywordStyle

  @impl LangSchema.Type
  def convert(%{properties: properties}, converter_mod, opts) do
    converted_properties =
      case opts |> Keyword.get(:ordered_properties, false) do
        false ->
          properties
          |> Map.new(fn {key, value} ->
            {to_string(key), LangSchema.Converter.convert(value, converter_mod, opts)}
          end)

        true ->
          if not KeywordStyle.keyword_style?(properties) do
            raise ArgumentError,
                  "Properties must be a keyword style(tuple with atom or string keys) when ordered_properties is true"
          end

          properties
          |> Enum.map(fn {key, value} ->
            {to_string(key), LangSchema.Converter.convert(value, converter_mod, opts)}
          end)
          |> Jason.OrderedObject.new()
      end

    required = properties |> Enum.map(fn {key, _} -> to_string(key) end)

    %{
      "properties" => converted_properties,
      "required" => required,
      "additionalProperties" => false
    }
  end
end
