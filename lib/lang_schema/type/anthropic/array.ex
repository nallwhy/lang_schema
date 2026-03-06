defmodule LangSchema.Type.Anthropic.Array do
  use LangSchema.Type

  @impl LangSchema.Type
  def convert(schema, mod, opts) do
    LangSchema.Type.Array.convert(schema, mod, opts)
  end

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:min_items]
  end
end
