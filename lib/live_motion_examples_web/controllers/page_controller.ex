defmodule LiveMotionExamplesWeb.PageController do
  use LiveMotionExamplesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
