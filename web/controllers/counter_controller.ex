defmodule Restfully.CounterController do
  use Restfully.Web, :controller

  alias Restfully.Counter

  plug :scrub_params, "counter" when action in [:create, :update]

  def index(conn, _params) do
    counters = Repo.all(Counter)
    render(conn, "index.json", counters: counters)
  end

  def create(conn, %{"counter" => counter_params}) do
    changeset = Counter.changeset(%Counter{}, counter_params)

    case Repo.insert(changeset) do
      {:ok, counter} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", counter_path(conn, :show, counter))
        |> render("show.json", counter: counter)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Restfully.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    counter = Repo.get!(Counter, id)
    render(conn, "show.json", counter: counter)
  end

  def update(conn, %{"id" => id, "counter" => counter_params}) do
    counter = Repo.get!(Counter, id)
    changeset = Counter.changeset(counter, counter_params)

    case Repo.update(changeset) do
      {:ok, counter} ->
        render(conn, "show.json", counter: counter)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Restfully.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    counter = Repo.get!(Counter, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(counter)

    send_resp(conn, :no_content, "")
  end

  # returns counter after update, increment of counter is synchronous.
  def next(conn, %{"id" => id}) do
    counter = Restfully.CounterSerial.transaction(
        fn() ->
            {:ok, counter} = Repo.transaction(
                fn() ->
                    Repo.get!(Counter, id)
                    |> increment_count
                    |> Repo.update!
                end
            )
            counter
        end
    )
    render(conn, "show.json", counter: counter)
  end

  # returns current counter value, increment of counter is done
  # asynchronously. Intended to show uncontrolled message queue growth
  # in the absense of back pressure.
  def incr(conn, %{"id" => id}) do
    counter = Repo.get!(Counter, id)
    Restfully.CounterSerial.async_transaction(
        fn() ->
            Repo.transaction(
                fn() ->
                    Repo.get!(Counter, id)
                    |> increment_count
                    |> Repo.update!
                end
            )
        end
    )
    noop = fn() -> :ok end
    for _ <- :lists.seq(1,100), do: Restfully.CounterSerial.async_transaction(noop)
    render(conn, "show.json", counter: counter)
  end

  defp increment_count(counter) do
    newcount = counter.count + 1
    Ecto.Changeset.change counter, count: newcount
  end
end
