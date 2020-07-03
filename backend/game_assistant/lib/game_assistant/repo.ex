defmodule GameAssistant.Repo do
  use Ecto.Repo,
    otp_app: :game_assistant,
    adapter: Ecto.Adapters.Postgres
end
