defmodule Trash.MixProject do
  use Mix.Project

  @repo_url "https://github.com/newaperio/trash"

  def project do
    [
      app: :trash,
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.11",
      elixirc_paths: ~w(lib test/support),
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
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
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [main: "readme", extras: ["README.md", "LICENSE"]]
  end

  defp package() do
    [
      description: "Simple soft deletes for Ecto",
      maintainers: ["Logan Leger"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url,
        "Made by NewAperio" => "https://newaperio.com"
      }
    ]
  end
end
