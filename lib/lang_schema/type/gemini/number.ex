defmodule LangSchema.Type.Gemini.Number do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:format]
  end
end
