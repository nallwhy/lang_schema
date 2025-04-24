defmodule LangSchema.Type.Object do
  use LangSchema.Type

  @impl LangSchema.Type
  def convert(%{properties: properties}, converter_mod, opts) do
    converted_properties =
      properties
      |> Map.new(fn {key, value} ->
        {to_string(key), LangSchema.Converter.convert(value, converter_mod, opts)}
      end)

    %{
      "properties" => converted_properties
    }
  end

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ LangSchema.Type.object_keywords()
  end
end
