defmodule LangSchema.Converter.Gemini do
  use LangSchema.Converter

  @impl LangSchema.Converter
  def types() do
    %{
      integer: LangSchema.Type.Gemini.Integer,
      number: LangSchema.Type.Gemini.Number,
      string: LangSchema.Type.Gemini.String,
      array: LangSchema.Type.Gemini.Array,
      object: LangSchema.Type.Gemini.Object
    }
  end

  @impl LangSchema.Converter
  def allowed_combinations() do
    []
  end
end
