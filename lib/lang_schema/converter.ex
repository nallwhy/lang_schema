defmodule LangSchema.Converter do
  @moduledoc """
  Defines the behaviour and provides a macro for creating specific schema converters.

  This module serves as a foundation for transforming an abstract schema definition
  into a JSON schema compatible with a specific AI provider (like OpenAI, Gemini, etc.).

  It defines the `to_schema/2` and `to_json_schema/2` callbacks that all specific converter
  modules must implement and provides a `__using__` macro to inject basic conversion logic
  and allow for customization.

  ## Usage

  To create a new converter for a specific provider, you `use LangSchema.Converter`
  within your module definition and implement the required callbacks.

  See `LangSchema.Converter.OpenAI` and `LangSchema.Converter.Gemini`.
  """

  @type combination() :: :any_of | :one_of | :all_of

  @doc """
  Converts a schema into a raw JSON schema.

  ## Options

  The supported options are:

  * `:ordered_properties` - If set to `true`, the properties of objects will be ordered
    according to the order they are defined in the schema. Default is `false`.

    When this option is enabled, the `properties` in the object schema should ideally be provided
    as a keyword list to preserve the order, since maps in Elixir do not retain insertion order.
    For providers like Gemini that support a separate `propertyOrdering` field, using a map may still work.
    However, if you're targeting multiple AI providers, using a keyword list is recommended to ensure consistent ordering behavior.

    Ordered properties may be serialized using `Jason.OrderedObject` to retain order in the
    resulting JSON string. This assumes that `Jason` is used for final serialization; other encoders are not currently supported for ordered output.
  """
  @callback to_schema(schema :: map(), opts :: keyword()) :: json_schema :: map()

  @doc """
  Converts a schema into a JSON schema wrapped in the provider-specific envelope.

  This calls `to_schema/2` internally and then passes the result through `wrap/2`.

  Accepts the same options as `to_schema/2`, plus any provider-specific options
  used by `wrap/2` (e.g., `:name` and `:description` for OpenAI).
  """
  @callback to_json_schema(schema :: map(), opts :: keyword()) :: json_schema :: map()

  @doc """
  Wraps the resulting JSON schema into a final structure required by the target provider.

  This function is used when a provider requires the JSON schema to be embedded within
  an additional enclosing structure. For example, OpenAI's Chat Completion expects the schema
  to be placed under a `"schema"` field.

  This function is also designed to be compatible with the `json_schema` input
  expected by the [LangChain](https://hex.pm/packages/langchain) library.

  By default, it returns the JSON schema as-is.
  You can override this function in a specific converter module to modify the wrapping behavior.
  """
  @callback wrap(json_schema :: map(), opts :: keyword()) :: json_schema :: map()

  @doc """
  Returns a map of custom type converters.

  This allows overriding or extending the default type conversion logic for each type.
  Keys must be atoms (e.g., `:string`, `:object`), and values must implement the corresponding conversion logic.

  See `LangSchema.Type` modules for how to define custom type converters.

  By default, returns an empty map.
  """
  @callback types() :: map()

  @doc """
  Returns the list of supported schema combination types.

  This specifies which JSON Schema combinators are allowed during conversion.
  Common values include `:any_of`, `:one_of`, and `:all_of`, corresponding to
  `anyOf`, `oneOf`, and `allOf` in the JSON Schema specification.

  You can override this in a specific converter module if a provider supports only a subset.
  """
  @callback allowed_combinations() :: list(combination())

  @doc """
  Returns a map of keyword-specific processors.

  Each key represents a JSON Schema keyword (e.g., `:pattern`, `:nullable`),
  and its value is a module responsible for processing that keyword during conversion.

  If a keyword is not explicitly handled, the behavior defined in `LangSchema.Keyword.Default` is applied.

  See `LangSchema.Keyword` for more details about keyword processing and extension.

  By default, returns an empty map.
  """
  @callback keywords() :: map()

  defmacro __using__(_opts) do
    quote do
      @behaviour LangSchema.Converter

      @impl LangSchema.Converter
      def to_schema(schema, opts \\ []) do
        unquote(__MODULE__).convert(schema, __MODULE__, opts)
      end

      @impl LangSchema.Converter
      def to_json_schema(schema, opts \\ []) do
        to_schema(schema, opts) |> wrap(opts)
      end

      @impl LangSchema.Converter
      def wrap(json_schema, _opts) do
        json_schema
      end

      @impl LangSchema.Converter
      def types() do
        %{}
      end

      @impl LangSchema.Converter
      def allowed_combinations() do
        [:any_of, :one_of, :all_of]
      end

      @impl LangSchema.Converter
      def keywords() do
        %{}
      end

      defoverridable wrap: 2, types: 0, allowed_combinations: 0, keywords: 0
    end
  end

  def convert(%{type: type} = schema, converter_mod, opts) do
    type_mod = Map.merge(default_types(), converter_mod.types()) |> Map.fetch!(type)
    type_str = type |> to_string()

    %{"type" => type_str}
    |> Map.merge(type_mod.convert(schema, converter_mod, opts))
    |> type_mod.convert_keywords(schema, converter_mod.keywords())
  end

  def convert(schema, converter_mod, opts) do
    allowed_combinations = converter_mod.allowed_combinations()

    schema
    |> Enum.map(fn {combination, value} ->
      if combination not in allowed_combinations do
        raise ArgumentError,
              "Invalid combination #{inspect(combination)}. Allowed combinations are: #{inspect(allowed_combinations)}"
      end

      {combination, value}
    end)
    |> Map.new(fn {combination, list} when is_list(list) ->
      {Recase.to_camel(to_string(combination)),
       list |> Enum.map(&convert(&1, converter_mod, opts))}
    end)
  end

  defp default_types() do
    %{
      boolean: LangSchema.Type.Boolean,
      integer: LangSchema.Type.Integer,
      number: LangSchema.Type.Number,
      string: LangSchema.Type.String,
      array: LangSchema.Type.Array,
      object: LangSchema.Type.Object
    }
  end
end
