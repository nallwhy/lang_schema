defmodule LangSchema.Converter.OpenAI do
  use LangSchema.Converter
  alias LangSchema.Util.Nillable

  @doc """
  Wraps the given JSON schema into the structure expected by OpenAI's Chat API when using `response_format: "json_schema"`.

  This implementation follows the specification described under:
  [OpenAI API Reference - Create Chat Completion](https://platform.openai.com/docs/api-reference/chat/create)
  (Request body → response_format → JSON schema → json_schema).

  It sets the `name`, attaches the provided JSON schema under the `schema` field, and enforces `strict: true`.
  If a `description` is provided in the options, it will be added as well.
  """
  @impl LangSchema.Converter
  def wrap(json_schema, opts) do
    name = Keyword.get(opts, :name, "response")
    description = Keyword.get(opts, :description)

    %{
      "name" => name,
      "schema" => json_schema,
      "strict" => true
    }
    |> Nillable.run_if(description, fn json_schema ->
      json_schema |> Map.put("description", description)
    end)
  end

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
