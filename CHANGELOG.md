# Changelog

## v0.5.0

### Breaking Changes

- `LangSchema.Converter.convert/2` has been split into two separate functions:
  - `to_schema/2`: Converts a schema into a raw JSON schema (previously `convert/2` with `wrap?: false`)
  - `to_json_schema/2`: Converts a schema into a JSON schema wrapped in the provider-specific envelope (previously `convert/2` with default `wrap?: true`)

#### Migration Guide

```elixir
# Before
converter.convert(schema, opts)             # wrapped (default)
converter.convert(schema, wrap?: false)     # raw

# After
converter.to_json_schema(schema, opts)      # wrapped
converter.to_schema(schema, opts)           # raw
```

## v0.4.0

- Bump langchain

## v0.3.0

- Create `LangSchema.Adapter.LangChainFunctionParam` for `LangChain.FunctionParam`
- Allow string keys for ordered object properties
- Fix order of `required` of `LangSchema.Type.OpenAI.Object`

## v0.2.0

- Add `wrap?` opt to `convert/2` callback function of `LangSchema.Converter`

## v0.1.0

- Implement `LangSchema.Converter.OpenAI`, `LangSchema.Converter.Gemini`
