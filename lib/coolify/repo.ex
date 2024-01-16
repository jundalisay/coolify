defmodule Coolify.Repo do
  use Ecto.Repo,
    otp_app: :coolify,
    adapter: Ecto.Adapters.Postgres
end
