defmodule LangSchema.Keyword.OpenAI.Nullable do
  use LangSchema.Keyword

  @impl LangSchema.Keyword
  def convert(json_schema, :nullable, value) do
    case value do
      true ->
        json_schema
        |> Map.update!("type", fn type -> [type, "null"] end)

      false ->
        json_schema
    end
  end
end
