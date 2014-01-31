defmodule Exhaml.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exhaml,
      version: "0.0.1",
      #elixir: "~> 0.12.1-dev",
      deps: deps,
      dialyzer: [
             flags: ["-Wunmatched_returns","-Werror_handling","-Wrace_conditions", "-Wno_opaque"],
             paths: ["_build/shared/lib/exhaml/ebin"]
           ]
    ]
  end

  def application do
    [mod: { Exhaml, [] }]
  end

  defp deps do
    []
  end
end
