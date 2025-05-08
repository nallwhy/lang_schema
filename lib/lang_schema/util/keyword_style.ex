defmodule LangSchema.Util.KeywordStyle do
  def keyword_style?([{key, _value} | rest]) when is_atom(key), do: keyword_style?(rest)
  def keyword_style?([{key, _value} | rest]) when is_binary(key), do: keyword_style?(rest)
  def keyword_style?([]), do: true
  def keyword_style?(_), do: false

  def keys([{key, _value} | rest]) when is_atom(key), do: [key | keys(rest)]
  def keys([{key, _value} | rest]) when is_binary(key), do: [key | keys(rest)]
end
