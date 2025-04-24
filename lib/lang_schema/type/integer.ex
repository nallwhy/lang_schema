defmodule LangSchema.Type.Integer do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ LangSchema.Type.numeric_keywords()
  end
end
