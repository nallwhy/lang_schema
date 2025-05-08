defmodule LangSchema.Adapter do
  @moduledoc """
  Defines a common behavior for adapters that convert various input types into abstract schemas or JSON schemas.

  The `LangSchema.Adapter` provides a flexible way to integrate different data structures into the LangSchema.
  It allows converting inputs like Struct typespecs, `LangChain.FunctionParam`, and Ash Resources into standardized
  abstract schemas or JSON schemas, making it easier to use them consistently within LangSchema.
  """

  @doc """
  Converts a given input into a JSON schema using the specified converter module.
  """
  @callback convert(any(), converter_mod :: module(), opts :: keyword()) :: json_schema :: map()

  @doc """
  Converts a given input into a schema using the specified converter module.
  """
  @callback to_schema(any()) :: schema :: map()
end
