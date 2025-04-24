defmodule LangSchema.Type.Array do
  use LangSchema.Type

  @impl LangSchema.Type
  def convert(%{items: items} = _schema, mod, opts) do
    %{
      "items" => LangSchema.Converter.convert(items, mod, opts)
    }
  end

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords()
  end
end
