defmodule LangSchema.Type.String do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ LangSchema.Type.string_keywords()
  end
end
