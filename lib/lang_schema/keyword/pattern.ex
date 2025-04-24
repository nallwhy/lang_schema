defmodule LangSchema.Keyword.Pattern do
  use LangSchema.Keyword

  @impl LangSchema.Keyword
  def convert(json_schema, :pattern, value) do
    pattern =
      case value do
        %Regex{} -> Regex.source(value)
        _ -> value
      end

    json_schema
    |> Map.put_new("pattern", pattern)
  end
end
