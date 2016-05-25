defmodule Restfully.CounterControllerTest do
  use Restfully.ConnCase

  alias Restfully.Counter
  @valid_attrs %{count: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, counter_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    counter = Repo.insert! %Counter{}
    conn = get conn, counter_path(conn, :show, counter)
    assert json_response(conn, 200)["data"] == %{"id" => counter.id,
      "name" => counter.name,
      "count" => counter.count}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, counter_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, counter_path(conn, :create), counter: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Counter, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, counter_path(conn, :create), counter: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    counter = Repo.insert! %Counter{}
    conn = put conn, counter_path(conn, :update, counter), counter: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Counter, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    counter = Repo.insert! %Counter{}
    conn = put conn, counter_path(conn, :update, counter), counter: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    counter = Repo.insert! %Counter{}
    conn = delete conn, counter_path(conn, :delete, counter)
    assert response(conn, 204)
    refute Repo.get(Counter, counter.id)
  end
end
