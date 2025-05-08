defmodule LangSchema.Adapter do
  @callback to_schema(any()) :: schema :: map()
  @callback convert(any(), converter_mod :: module(), opts :: keyword()) :: json_schema :: map()
end
