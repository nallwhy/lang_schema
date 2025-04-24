defmodule LangSchema.Converter.OpenAI.ChatCompletion do
  use LangSchema.Converter.OpenAI
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
end
