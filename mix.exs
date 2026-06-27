defmodule TailwindCompiler.MixProject do
  use Mix.Project

  def project do
    [
      app: :tailwind_compiler,
      version: "0.0.7",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, inets: :optional, ssl: :optional]
    ]
  end

  defp deps do
    [
      {:zigler, github: "bcardarella/zigler", runtime: false, optional: not force_build?()},
      {:nimble_parsec, "~> 1.4"},
      {:jason, "~> 1.4", runtime: false}
    ]
  end

  defp force_build? do
    System.get_env("TAILWIND_COMPILER_PATH") != nil
  end
end
