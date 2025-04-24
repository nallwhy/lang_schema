defmodule LangSchema.Type.OpenAI.Array do
  use LangSchema.Type

  @impl LangSchema.Type
  def convert(schema, mod, opts) do
    LangSchema.Type.Array.convert(schema, mod, opts)
  end
end
