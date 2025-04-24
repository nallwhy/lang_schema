defmodule LangSchema.Type do
  @moduledoc """
  Defines the behaviour and common helpers for handling JSON Schema type conversion.

  Each module implementing `LangSchema.Type` specifies how a particular JSON Schema `type`
  (such as `boolean`, `integer`, `number`, `string`, `array`, or `object`) should be converted
  into its corresponding JSON Schema representation.

  It also provides shared utilities for processing schema keywords during conversion.
  """

  @doc """
  Defines how the core part of the given type should be converted into its corresponding JSON Schema representation.

  This focuses on converting the essential structure specific to the type — for example,
  handling `properties` for `object`, or `items` for `array`.

  Complex types like `object` and `array` will typically implement meaningful logic here.
  """
  @callback convert(schema :: map(), mod :: module(), opts :: keyword()) :: json_schema :: map()

  @doc """
  Returns the list of allowed keywords that can be additionally set for this type.

  In JSON Schema, various keywords (such as `description`, `minimum`, `pattern`, etc.)
  can be used to further constrain or describe a field beyond its basic type.

  This callback defines which keywords are considered relevant for the type
  and will be processed during schema conversion.

  Within this Elixir codebase, keyword names follow Elixir's snake_case convention
  (e.g., `min_length`, `max_items`), even though in JSON Schema they are typically camelCase
  (e.g., `minLength`, `maxItems`).
  """
  @callback keywords() :: list(atom())

  @doc """
  Converts and attaches additional keywords to the JSON schema for this type.

  This function applies the allowed keywords (as defined by `keywords/0`) onto the base JSON schema
  according to the values provided in the original schema definition.

  By default, the `pattern` keyword is predefined with its specific converter.
  If a keyword is not explicitly associated with a converter, the behavior defined by `LangSchema.Keyword.Default` is applied.
  """
  @callback convert_keywords(json_schema :: map(), schema :: map(), keywords :: map()) ::
              json_schema :: map()

  defmacro __using__(_opts) do
    quote do
      @behaviour LangSchema.Type

      @impl LangSchema.Type
      def convert(_schema, _mod, _opts) do
        %{}
      end

      @impl LangSchema.Type
      def keywords() do
        unquote(__MODULE__).common_keywords()
      end

      @impl LangSchema.Type
      def convert_keywords(json_schema, schema, keywords) do
        unquote(__MODULE__).convert_keywords(
          json_schema,
          schema,
          keywords,
          __MODULE__
        )
      end

      defoverridable convert: 3, keywords: 0
    end
  end

  def convert_keywords(json_schema, schema, keywords, type_mod) do
    keyword_converters = Map.merge(default_keyword_converters(), keywords)

    type_mod.keywords()
    |> Enum.reduce(json_schema, fn keyword, json_schema ->
      case Map.get(schema, keyword) do
        nil ->
          json_schema

        value ->
          keyword_converter = keyword_converters[keyword] || keyword_converters[:_default]

          keyword_converter.convert(json_schema, keyword, value)
      end
    end)
  end

  def common_keywords() do
    [:description, :nullable]
  end

  def numeric_keywords() do
    [:enum, :minimum, :maximum]
  end

  def string_keywords() do
    [:enum, :min_length, :max_length, :format, :pattern]
  end

  def array_keywords() do
    [:min_items, :max_items, :unique_items]
  end

  def object_keywords() do
    [:additional_properties, :required]
  end

  defp default_keyword_converters() do
    %{
      pattern: LangSchema.Keyword.Pattern,
      _default: LangSchema.Keyword.Default
    }
  end
end
