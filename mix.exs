defmodule PhoenixLiveViewTestBrowser.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :phoenix_live_view_test_browser,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: compilers(Mix.env()),
      deps: deps(),
      name: "Phoenix LiveView Test Browser",
      description: "Test utilities for LV"
    ]
  end

  defp compilers(:test), do: [:phoenix] ++ Mix.compilers()
  defp compilers(_), do: Mix.compilers()

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, ">= 0.12.0"},
      {:floki, ">= 0.24.0"},
      {:jason, "~> 1.0", optional: true}
    ]
  end
end
