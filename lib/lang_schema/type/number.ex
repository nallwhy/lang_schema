defmodule LangSchema.Type.Number do
  use LangSchema.Type

  @impl LangSchema.Type
  def keywords() do
    Enum.concat([
      LangSchema.Type.common_keywords(),
      LangSchema.Type.numeric_keywords(),
      [:multiple_of]
    ])
  end
end
