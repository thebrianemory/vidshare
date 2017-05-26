defmodule Vidshare.AuthControllerTest do
  use Vidshare.ConnCase

  test "Sign in with GitHub", %{conn: conn} do
    conn = get conn, "/auth/github?scope=read%3Auser+user%3Aemail+read%3Aorg"
    assert redirected_to(conn, 302)
  end
end
