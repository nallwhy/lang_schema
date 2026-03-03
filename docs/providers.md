# Provider Structured Output Reference

Structured output / JSON schema support reference for each provider, including `structured_output/2` envelope structure and supported JSON Schema keywords.

## OpenAI

**Docs**: https://platform.openai.com/docs/guides/structured-outputs/supported-schemas

**LangSchema converter**: `LangSchema.Converter.OpenAI`

### `structured_output/2` envelope

```json
{
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "response",
      "strict": true,
      "schema": { ... }
    }
  }
}
```

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

- All fields must be `required`
- `additionalProperties` must be `false` on every object
- Max 100 object properties total, up to 5 levels of nesting

---

## Gemini

**Docs**: https://ai.google.dev/gemini-api/docs/structured-output

**LangSchema converter**: `LangSchema.Converter.Gemini`

### `structured_output/2` envelope

```json
{
  "generationConfig": {
    "responseMimeType": "application/json",
    "responseSchema": { ... }
  }
}
```

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

### Constraints

- Unsupported properties are silently ignored
- Very large or deeply nested schemas may be rejected

---

## Anthropic (Claude)

**Docs**: https://platform.claude.com/docs/en/build-with-claude/structured-outputs

**LangSchema converter**: `LangSchema.Converter.Anthropic` (not yet implemented)

### `structured_output/2` envelope

```json
{
  "output_config": {
    "format": {
      "type": "json_schema",
      "schema": { ... }
    }
  }
}
```

For tool use, the schema goes in `input_schema` at the tool level:

```json
{
  "tools": [{
    "name": "...",
    "input_schema": { ... },
    "strict": true
  }]
}
```

### Supported types

`string`, `number`, `integer`, `boolean`, `object`, `array`, `null`

### Supported keywords

- `type`, `description`, `enum` (strings, numbers, bools, nulls — no complex types), `const`, `default`
- `properties`, `required`, `additionalProperties` (must be `false`)
- `items`, `minItems` (only `0` or `1`)
- `anyOf`, `allOf` (limited — `allOf` with `$ref` not supported)
- `$ref`, `$defs`, `definitions` (no external `$ref`)
- `format` (`date-time`, `date`, `time`, `duration`, `email`, `hostname`, `uri`, `ipv4`, `ipv6`, `uuid`)
- `pattern` (subset of regex — no backreferences, lookahead/lookbehind, `\b`)

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
- Incompatible with citations and message prefilling

---

## xAI (Grok)

**Docs**: https://docs.x.ai/docs/guides/structured-outputs

**LangSchema provider atom**: `:xai` (uses `LangSchema.Converter.OpenAI` — identical envelope)

### `structured_output/2` envelope

Identical to OpenAI:

```json
{
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "...",
      "strict": true,
      "schema": { ... }
    }
  }
}
```

### Supported types

`string`, `number`, `integer`, `boolean`, `object`, `array`, `enum`, `anyOf`

### Supported keywords

- `type`, `description`, `enum`, `anyOf`
- `properties`, `required`
- `items`

### Unsupported keywords

- `allOf`
- `minLength`, `maxLength`
- `minItems`, `maxItems`, `minContains`, `maxContains`

### Constraints

- Structured outputs only available for Grok 4 family models

---

## Ollama

**Docs**: https://docs.ollama.com/capabilities/structured-outputs

**LangSchema converter**: `LangSchema.Converter.Ollama` (not yet implemented)

### `structured_output/2` envelope

Ollama's native API puts the schema directly at the request root:

```json
{
  "format": { ... }
}
```

Via the OpenAI-compatible endpoint (`/v1/chat/completions`), the standard OpenAI `response_format` envelope is used instead.

### Supported types

`string`, `number`, `integer`, `boolean`, `object`, `array`

### Supported keywords

- `type`, `properties`, `required`, `items`
- (No explicit list published; depends on underlying llama.cpp grammar engine)

### Constraints

- `format` sits at the request root — differs from all other providers
- Model capability varies widely; not all models support structured output equally
- Recommend including the schema in the prompt text for best results
- Recommend `temperature: 0` for more deterministic output

---

## Mistral AI

**Docs**: https://docs.mistral.ai/capabilities/structured_output/custom

**LangSchema provider atom**: `:mistral` (uses `LangSchema.Converter.OpenAI` — identical envelope)

### `structured_output/2` envelope

Identical to OpenAI:

```json
{
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "...",
      "strict": true,
      "schema": { ... }
    }
  }
}
```

### Supported types

`string`, `number`, `integer`, `boolean`, `object`, `array`, `enum`

### Supported keywords

- `type`, `title`, `description`, `enum`
- `properties`, `required`, `additionalProperties`
- `items`

### Constraints

- `name` field inside `json_schema` is required
- All models support structured output except `codestral-mamba`

---

## LM Studio

**Docs**: https://lmstudio.ai/docs/developer/openai-compat/structured-output

**LangSchema provider atom**: `:lmstudio` (uses `LangSchema.Converter.OpenAI` — identical envelope)

### `structured_output/2` envelope

Identical to OpenAI:

```json
{
  "response_format": {
    "type": "json_schema",
    "json_schema": {
      "name": "...",
      "strict": true,
      "schema": { ... }
    }
  }
}
```

### Supported types

`string`, `number`, `integer`, `boolean`, `object`, `array`

### Supported keywords

- `type`, `properties`, `required`, `items`, `minItems`
- (Depends on model format: GGUF uses llama.cpp grammar, MLX uses Outlines library)

### Constraints

- Supported keywords differ by model format (GGUF vs MLX)
- Models under ~7B parameters often cannot reliably follow structured output schemas

---

## Summary

| Provider | `structured_output` envelope path | LangSchema provider atom |
|---|---|---|
| OpenAI | `response_format.json_schema.schema` | `:openai` |
| Gemini | `generationConfig.responseSchema` | `:gemini` |
| Anthropic | `output_config.format.schema` | not yet implemented |
| xAI | `response_format.json_schema.schema` | `:xai` (uses `Converter.OpenAI`) |
| Ollama | `format` (root, no wrapper) | not yet implemented |
| Mistral | `response_format.json_schema.schema` | `:mistral` (uses `Converter.OpenAI`) |
| LM Studio | `response_format.json_schema.schema` | `:lmstudio` (uses `Converter.OpenAI`) |
