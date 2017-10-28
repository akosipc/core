defmodule OpenBudgetWeb.UserControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User
  alias OpenBudget.Guardian.Authentication, as: GuardianAuth

  @create_attrs %{email: "test@example.com", password: "secretpassword"}
  @update_attrs %{email: "updated@example.com", password: "updatedsecretpassword"}
  @invalid_attrs %{email: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Authentication.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      user = fixture(:user)
      conn =
        conn
        |> GuardianAuth.sign_in(user)
        |> get(user_path(conn, :index))

      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "show" do
    test "display a user", %{conn: conn} do
      user = fixture(:user)
      conn =
        conn
        |> GuardianAuth.sign_in(user)
        |> get(user_path(conn, :show, user.id))

      assert json_response(conn, 200)["data"] == %{
        "type" => "user",
        "id" => "#{user.id}",
        "attributes" => %{
          "email" => "test@example.com"
        },
        "links" => %{
          "self" => "/users/#{user.id}"
        },
        "relationships" => %{
          "active-budget" => %{}
        }
      }
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @create_attrs}})
      conn = post conn, user_path(conn, :create), params
      response = json_response(conn, 201)["data"]
      {auth_header, _} = hd(Enum.reverse(conn.resp_headers))

      assert auth_header == "authorization"
      assert response["attributes"] == %{
        "email" => "test@example.com"
      }
      assert response["relationships"]["active-budget"]["data"]["id"] != ""
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = post conn, user_path(conn, :create), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: _id} = user} do
      params = Poison.encode!(%{data: %{attributes: @update_attrs}})
      conn =
        conn
        |> GuardianAuth.sign_in(user)
        |> put(user_path(conn, :update, user), params)
      response = json_response(conn, 200)["data"]

      assert response["attributes"] == %{
        "email" => "updated@example.com"
      }
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn =
        conn
        |> GuardianAuth.sign_in(user)
        |> put(user_path(conn, :update, user), params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn =
        conn
        |> GuardianAuth.sign_in(user)
        |> delete(user_path(conn, :delete, user))
      assert response(conn, 204)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
