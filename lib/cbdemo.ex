defmodule Cbdemo do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(Cbdemo.Worker, [%Cbserverapi{host: '198.re.dac.ted', password: "Apassword", port: 5004, username: "cb"}, "ingress.event.netconn"])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cbdemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
