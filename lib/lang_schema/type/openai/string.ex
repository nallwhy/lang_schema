defmodule LangSchema.Type.OpenAI.String do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:enum]
  end
end
