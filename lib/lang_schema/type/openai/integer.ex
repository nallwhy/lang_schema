defmodule LangSchema.Type.OpenAI.Integer do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:enum]
  end
end
