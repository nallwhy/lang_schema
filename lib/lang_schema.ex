defmodule LangSchema do
  @providers %{
    openai: LangSchema.Converter.OpenAI,
    gemini: LangSchema.Converter.Gemini
  }

  @type provider :: :openai | :gemini

  @doc """
  Converts a schema into a raw JSON schema using the given provider.
  """
  @spec to_schema(map(), provider(), keyword()) :: map()
  def to_schema(schema, provider, opts \\ []) do
    converter(provider).to_schema(schema, opts)
  end

  @doc """
  Converts a schema into a JSON schema wrapped in the provider-specific envelope.
  """
  @spec to_json_schema(map(), provider(), keyword()) :: map()
  def to_json_schema(schema, provider, opts \\ []) do
    converter(provider).to_json_schema(schema, opts)
  end

  defp converter(provider) do
    @providers[provider] ||
      raise ArgumentError,
            "Invalid provider #{inspect(provider)}. Valid providers are: #{@providers |> Map.keys() |> Enum.sort() |> inspect()}"
  end
end
