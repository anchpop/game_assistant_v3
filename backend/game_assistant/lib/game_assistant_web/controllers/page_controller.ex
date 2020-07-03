defmodule GameAssistantWeb.PageController do
  use GameAssistantWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
