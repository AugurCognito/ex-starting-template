defmodule App.MixProject do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      elixirc_options: [warnings_as_errors: true],
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls, minimum_coverage: 80.0],
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test]
    ]
  end

  def cli do
    [preferred_envs: [precommit: :test]]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4", only: [:dev, :test], runtime: false},
      {:ex_dna, "~> 1.5", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.11", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.14", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:git_ops, "~> 2.10", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:stream_data, "~> 1.3", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      # THE definition of done — cheapest gate first, fail fast.
      precommit: [
        "deps.unlock --check-unused",
        "hex.audit",
        "deps.audit",
        "format --check-formatted",
        "compile --warnings-as-errors",
        "credo --strict",
        "ex_dna --max-clones 2",
        "sobelow --exit",
        "coveralls"
      ]
    ]
  end
end
