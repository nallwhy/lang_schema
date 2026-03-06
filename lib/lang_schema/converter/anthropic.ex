defmodule LangSchema.Converter.Anthropic do
  @moduledoc """
  Converts a LangSchema into a JSON schema compatible with Anthropic's Structured Outputs.

  ## Supported JSON Schema spec

  Reference: https://platform.claude.com/docs/en/build-with-claude/structured-outputs

  ### Supported types

  `string`, `number`, `integer`, `boolean`, `object`, `array`, `null`

  ### Supported keywords

  - `type`, `description`, `enum` (strings, numbers, bools, nulls), `const`, `default`
  - `properties`, `required`, `additionalProperties` (must be `false`)
  - `items`, `minItems` (only `0` or `1`)
  - `anyOf`, `allOf` (limited — `allOf` with `$ref` not supported)
  - `$ref`, `$defs`, `definitions` (no external `$ref`)
  - `format` (`date-time`, `date`, `time`, `duration`, `email`, `hostname`, `uri`, `ipv4`, `ipv6`, `uuid`)
  - `pattern` (subset of regex — no backreferences, lookahead/lookbehind, `\\b`)

  ### Unsupported keywords

  - `minimum`, `maximum`, `multipleOf`
  - `minLength`, `maxLength`
  - `minItems` beyond `0` or `1`, `maxItems`
  - `additionalProperties` set to anything other than `false`
  - Recursive schemas

  ### Constraints

  - `additionalProperties: false` is mandatory on all objects
  - Max 20 strict tools per request
  - Max 24 optional parameters total across all strict schemas
  - Max 16 parameters using `anyOf` or type arrays across all strict schemas
  - First-request grammar compilation adds 100–300ms; cached 24 hours

  ## LangSchema implementation status

  | Keyword | Status |
  |---|---|
  | `type`, `description`, `enum` | Supported |
  | `properties`, `required`, `additionalProperties` | Supported (auto-enforced) |
  | `items`, `minItems` | Supported |
  | `format`, `pattern` | Supported |
  | `nullable` | Supported (via `["type", "null"]`) |
  | `anyOf` | Supported |
  | `const`, `default` | Not yet implemented |
  | `$ref`, `$defs` | Not yet implemented |
  | `allOf` | Not yet implemented |
  """

  use LangSchema.Converter

  @impl LangSchema.Converter
  def types() do
    %{
      integer: LangSchema.Type.Anthropic.Integer,
      number: LangSchema.Type.Anthropic.Number,
      string: LangSchema.Type.Anthropic.String,
      array: LangSchema.Type.Anthropic.Array,
      object: LangSchema.Type.Anthropic.Object,
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
      nullable: LangSchema.Keyword.Anthropic.Nullable
    }
  end
end
