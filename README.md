# LangSchema

Converts an abstract schema into JSON schemas required by various AI providers, minimizing code changes when switching providers.

## Design Goals

LangSchema aims to define an abstract schema that can be commonly applied across different AI providers, allowing you to switch providers without modifying your original schema. While provider-specific features are not entirely excluded, supporting every custom feature is not the primary goal. Instead, LangSchema prioritizes raising errors when a schema might implicitly behave incorrectly due to differences between providers, making such issues explicit and easier to fix.

## Supported AI providers

- OpenAI
  - [LangSchema.Converter.OpenAI.ChatCompletion](./lib/lang_schema/converter/openai/chat_completion.ex)
  - [LangSchema.Converter.OpenAI.Function](./lib/lang_schema/converter/openai/function.ex)
- Gemini
  - [LangSchema.Converter.Gemini](./lib/lang_schema/converter/gemini.ex)

## Writing a Custom Converter

You can create your own converter for a new AI provider by implementing the `LangSchema.Converter` behaviour.

Here's a simple example based on the OpenAI converter:

```elixir
defmodule MyApp.LangSchema.Converter.MyProvider do
  use LangSchema.Converter

  @impl LangSchema.Converter
  def wrap(json_schema, opts) do
    name = Keyword.get(opts, :name, "response")

    %{
      "name" => name,
      "schema" => json_schema
    }
  end

  @impl LangSchema.Converter
  def types() do
    # Add type converters
    %{
      integer: MyApp.LangSchema.Type.MyProvider.Integer,
      number: MyApp.LangSchema.Type.MyProvider.Number,
      string: MyApp.LangSchema.Type.MyProvider.String,
      array: MyApp.LangSchema.Type.MyProvider.Array,
      object: MyApp.LangSchema.Type.MyProvider.Object
    }
  end

  @impl LangSchema.Converter
  def allowed_combinations() do
    # List only the combinations your provider supports, e.g., :any_of, :one_of, :all_of
    [:any_of] 
  end

  @impl LangSchema.Converter
  def keywords() do
    %{
      # Add keyword converters
      nullable: MyApp.LangSchema.Keyword.MyProvider.Nullable
    }
  end
end
```

## Installation

The package can be installed by adding `lang_schema` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:lang_schema, "~> 0.1.0"}
  ]
end
```

## Relationship with Elixir LangChain

Elixir [LangChain](https://hex.pm/packages/langchain) library provides support for function calling by accepting a `json_schema`.
LangSchema is designed so that the output of each converter’s `wrap/2` function can be directly used as a json_schema in LangChain without additional modifications.
