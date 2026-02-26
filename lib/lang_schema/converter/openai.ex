defmodule LangSchema.Converter.OpenAI do
  @moduledoc """
  Converts a LangSchema into a JSON schema compatible with OpenAI's Structured Outputs.

  ## Supported JSON Schema spec

  Reference: https://platform.openai.com/docs/guides/structured-outputs/supported-schemas

  ### Supported types

  `string`, `number`, `integer`, `boolean`, `object`, `array`, `enum`, `anyOf`

  > Root objects cannot be `anyOf` type.

  ### Supported keywords

  - `type`, `description`, `enum`, `const`
  - `properties`, `required`, `additionalProperties` (must be `false`)
  - `items`, `anyOf`
  - `$ref`, `$defs` (recursive schemas supported)

  ### Unsupported keywords

  | Type | Unsupported keywords |
  |---|---|
  | String | `minLength`, `maxLength`, `pattern`, `format` |
  | Number | `minimum`, `maximum`, `multipleOf` |
  | Object | `patternProperties`, `unevaluatedProperties`, `propertyNames`, `minProperties`, `maxProperties` |
  | Array | `unevaluatedItems`, `contains`, `minContains`, `maxContains`, `minItems`, `maxItems`, `uniqueItems` |

  ### Constraints

  - All fields must be `required`.
  - `additionalProperties` must be `false` on every object.
  - Max 100 object properties total, up to 5 levels of nesting.

  ## LangSchema implementation status

  | Keyword | Status |
  |---|---|
  | `type`, `description`, `enum` | Supported |
  | `properties`, `required`, `additionalProperties` | Supported (auto-enforced) |
  | `items` | Supported |
  | `anyOf` | Supported |
  | `nullable` | Supported (via `["type", "null"]`) |
  | `const` | Not yet implemented |
  | `$ref`, `$defs` | Not yet implemented |
  """

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
      object: LangSchema.Type.OpenAI.Object,
      null: LangSchema.Type.Null
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
