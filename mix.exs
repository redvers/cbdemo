defmodule Cbdemo.Mixfile do
  use Mix.Project

  def project do
    [app: :cbdemo,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :syslog, :cbserverapi],
     mod: {Cbdemo, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:cbserverapi, git: "https://github.com/redvers/cbserverapi.git"},
      {:syslog, git: "https://github.com/smpallen99/syslog.git"},
      {:exrm, "~> 0.18.5"}
    ]
  end
end
