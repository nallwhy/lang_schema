defmodule LangSchema.Converter.OpenAI.Function do
  use LangSchema.Converter.OpenAI

  @impl LangSchema.Converter
  def wrap(json_schema, _opts) do
    json_schema
  end
end
