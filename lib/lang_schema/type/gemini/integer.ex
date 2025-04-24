defmodule LangSchema.Type.Gemini.Integer do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:format]
  end
end
