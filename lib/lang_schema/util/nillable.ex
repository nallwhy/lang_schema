defmodule LangSchema.Util.Nillable do
  def run_if(target, nil, _fun), do: target
  def run_if(target, _not_nil, fun) when is_function(fun, 1), do: target |> fun.()
  def run_if(target, not_nil, fun) when is_function(fun, 2), do: target |> fun.(not_nil)
end
