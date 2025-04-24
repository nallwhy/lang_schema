defmodule LangSchema.Keyword.Default do
  use LangSchema.Keyword

  @impl LangSchema.Keyword
  def convert(json_schema, keyword, value) do
    keyword_str = keyword |> to_string() |> Recase.to_camel()
    normalized_value = normalize_value(value)

    json_schema
    |> Map.put_new(keyword_str, normalized_value)
  end

  defp normalize_value(value) do
    case value do
      value when is_boolean(value) -> value
      value when is_atom(value) -> value |> Atom.to_string()
      value when is_list(value) -> value |> Enum.map(&normalize_value/1)
      _ -> value
    end
  end
end
