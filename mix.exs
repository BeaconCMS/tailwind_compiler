defmodule TailwindCompiler.MixProject do
  use Mix.Project

  def project do
    [
      app: :tailwind_compiler,
      version: "0.0.5",
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
      {:zigler, "~> 0.15.1", runtime: false, optional: true},
      {:jason, "~> 1.4", runtime: false}
    ]
  end
end
