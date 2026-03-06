defmodule LangSchema do
  @providers %{
    openai: LangSchema.Converter.OpenAI,
    google: LangSchema.Converter.Google
  }

  @type provider :: :openai | :google

  @doc """
  Converts a schema into a provider-specific JSON schema for function calling (tool use).
  """
  @spec function_calling(map(), provider(), keyword()) :: map()
  def function_calling(schema, provider, opts \\ []) do
    converter(provider).function_calling(schema, opts)
  end

  @doc """
  Converts a schema into a JSON schema wrapped in the provider-specific envelope for structured output.
  """
  @spec structured_output(map(), provider(), keyword()) :: map()
  def structured_output(schema, provider, opts \\ []) do
    converter(provider).structured_output(schema, opts)
  end

  defp converter(provider) do
    @providers[provider] ||
      raise ArgumentError,
            "Invalid provider #{inspect(provider)}. Valid providers are: #{@providers |> Map.keys() |> Enum.sort() |> inspect()}"
  end
end
