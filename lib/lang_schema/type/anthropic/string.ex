defmodule LangSchema.Type.Anthropic.String do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    LangSchema.Type.common_keywords() ++ [:enum, :format, :pattern]
  end
end
