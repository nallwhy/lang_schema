defmodule LangSchema.Converter.Google do
  @moduledoc """
  Converts a LangSchema into a JSON schema compatible with Gemini's Structured Outputs.

  ## Supported JSON Schema spec

  Reference: https://ai.google.dev/gemini-api/docs/structured-output

  ### Supported types

  `string`, `number`, `integer`, `boolean`, `object`, `array`, `null`

  ### Supported keywords

  - `type`, `title`, `description`, `enum`
  - `properties`, `required`, `additionalProperties`
  - `items`, `prefixItems`, `minItems`, `maxItems`
  - `minimum`, `maximum` (number/integer)
  - `format` (`date-time`, `date`, `time` for strings)
  - `anyOf`, `$ref`, `$defs` (since Nov 2025, Gemini 2.5+)
  - `nullable`
  - `propertyOrdering` (Gemini 2.0+, implicit ordering in Gemini 2.5+)

  ### Limitations

  - Not all JSON Schema features are supported; unsupported properties are ignored.
  - Very large or deeply nested schemas may be rejected.

  ## LangSchema implementation status

  | Keyword | Status |
  |---|---|
  | `type`, `description`, `enum` (string only) | Supported |
  | `properties`, `required` | Supported |
  | `items`, `minItems`, `maxItems` | Supported |
  | `format` (integer, number, string) | Supported |
  | `nullable` | Supported (via `"nullable": true`) |
  | `propertyOrdering` | Supported (via `ordered_properties` option) |
  | `title` | Not yet implemented |
  | `enum` (number/integer) | Not yet implemented |
  | `minimum`, `maximum` | Not yet implemented |
  | `additionalProperties` | Not yet implemented |
  | `prefixItems` | Not yet implemented |
  | `anyOf`, `$ref`, `$defs` | Not yet implemented |
  """

  use LangSchema.Converter

  @impl LangSchema.Converter
  def types() do
    %{
      integer: LangSchema.Type.Google.Integer,
      number: LangSchema.Type.Google.Number,
      string: LangSchema.Type.Google.String,
      array: LangSchema.Type.Google.Array,
      object: LangSchema.Type.Google.Object,
      null: LangSchema.Type.Null
    }
  end

  @impl LangSchema.Converter
  def allowed_combinations() do
    []
  end
end
