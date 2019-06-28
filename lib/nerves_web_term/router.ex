defmodule NervesWebTerm.Router do
  use Plug.Router

  plug(:static_index)

  # Rewrite / to "index.html" so Plug.Static finds a match
  def static_index(%{request_path: "/"} = conn, _opts) do
    %{conn | :path_info => ["index.html"]}
  end

  plug(Plug.Static,
    at: "/",
    from: :nerves_web_term
  )

  plug(:match)
  plug(:dispatch)

  match _ do
    send_resp(conn, 404, "404")
  end
end
