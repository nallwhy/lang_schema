defmodule LangSchema.Converter.Gemini do
  use LangSchema.Converter

  @impl LangSchema.Converter
  def types() do
    %{
      integer: LangSchema.Type.Gemini.Integer,
      number: LangSchema.Type.Gemini.Number,
      string: LangSchema.Type.Gemini.String,
      array: LangSchema.Type.Gemini.Array,
      object: LangSchema.Type.Gemini.Object,
      null: LangSchema.Type.Null
    }
  end

  @impl LangSchema.Converter
  def allowed_combinations() do
    []
  end
end
