defmodule Vidshare.PageController do
  use Vidshare.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
