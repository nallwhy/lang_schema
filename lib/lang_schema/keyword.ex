defmodule LangSchema.Keyword do
  @moduledoc """
  Defines the behaviour for modules that handle JSON Schema keywords.

  If no specific keyword module exists, default behavior is provided by `LangSchema.Keyword.Default`.
  """

  @doc """
  Converts and attaches a specific keyword to the JSON schema.

  This function defines how a single keyword-value pair should be applied to the given JSON schema map.

  The `keyword` argument is provided in snake_case format (e.g., `min_length`), and the implementer is responsible
  for converting it to the appropriate camelCase JSON Schema field (e.g., `minLength`) if necessary.

  This allows fine-grained control over the transformation of each keyword during schema generation.
  """
  @callback convert(json_schema :: map(), keyword :: atom(), value :: any()) ::
              json_schema :: map()

  defmacro __using__(_opts) do
    quote do
      @behaviour LangSchema.Keyword
    end
  end
end
