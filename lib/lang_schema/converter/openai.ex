defmodule LangSchema.Converter.OpenAI do
  defmacro __using__(_opts) do
    quote do
      use LangSchema.Converter

      @impl LangSchema.Converter
      def types() do
        %{
          integer: LangSchema.Type.OpenAI.Integer,
          number: LangSchema.Type.OpenAI.Number,
          string: LangSchema.Type.OpenAI.String,
          array: LangSchema.Type.OpenAI.Array,
          object: LangSchema.Type.OpenAI.Object
        }
      end

      @impl LangSchema.Converter
      def allowed_combinations() do
        [:any_of]
      end

      @impl LangSchema.Converter
      def keywords() do
        %{
          nullable: LangSchema.Keyword.OpenAI.Nullable
        }
      end
    end
  end
end
