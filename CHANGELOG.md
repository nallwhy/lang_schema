# Changelog

## v0.7.0

### Breaking Changes

- `:gemini` provider atom renamed to `:google` for naming consistency with other libraries

#### Migration Guide

```elixir
# Before
LangSchema.function_calling(schema, :gemini)
LangSchema.structured_output(schema, :gemini)

# After
LangSchema.function_calling(schema, :google)
LangSchema.structured_output(schema, :google)
```

### New Features

- Add `LangSchema.Converter.Anthropic` for Anthropic (Claude) structured outputs and function calling
- Bump langchain to `~> 0.6.1`

## v0.6.0

### Breaking Changes

- `to_schema/2` and `to_json_schema/2` have been renamed to clarify their purpose:
  - `function_calling/2`: Converts a schema into a provider-specific JSON schema for function calling (tool use)
  - `structured_output/2`: Converts a schema into a JSON schema wrapped in the provider-specific envelope for structured output

#### Migration Guide

```elixir
# Before
LangSchema.to_schema(schema, :openai)           # raw JSON schema
LangSchema.to_json_schema(schema, :openai)       # wrapped in envelope

# After
LangSchema.function_calling(schema, :openai)     # for function calling / tool use
LangSchema.structured_output(schema, :openai)    # for structured output
```

## v0.5.0

### Breaking Changes

- `LangSchema.Converter.convert/2` has been split into two separate functions:
  - `to_schema/2` → now `function_calling/2`
  - `to_json_schema/2` → now `structured_output/2`

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
