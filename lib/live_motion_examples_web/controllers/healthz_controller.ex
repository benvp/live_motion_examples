defmodule LiveMotionExamplesWeb.HealthzController do
  use LiveMotionExamplesWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "OK")
  end
end
