defmodule LangSchema.MixProject do
  use Mix.Project

  @source_url "https://github.com/nallwhy/lang_schema"
  @version "0.3.0"

  def project do
    [
      app: :lang_schema,
      version: @version,
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: &docs/0,
      name: "LangSchema",
      homepage_url: @source_url,
      description: """
      Converts an abstract schema into JSON schemas required by various AI providers, minimizing code changes when switching providers.
      """
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:recase, "~> 0.8.1"},
      {:jason, "~> 1.3"},
      {:langchain, "~> 0.4.0-rc.0", optional: true},
      {:ex_doc, "~> 0.34", only: :doc, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: [
        "README.md": [title: "Overview"]
      ]
    ]
  end

  defp package do
    [
      name: :lang_schema,
      licenses: ["MIT"],
      maintainers: ["Jinkyou Son"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
