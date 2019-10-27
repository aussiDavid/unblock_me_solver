defmodule UnblockMeSolver.MixProject do
  use Mix.Project

  def project do
    [
      app: :unblock_me_solver,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "UnblockMeSolver",
      source_url: "https://github.com/aussiDavid/unblock_me_solver",
      homepage_url: "https://github.com/aussiDavid/unblock_me_solver",
      docs: [
        main: "UnblockMeSolver",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end
end
