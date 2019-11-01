defmodule Trivium.PostGIS do
  @moduledoc """
  The Private context.
  """

  import Ecto.Query, warn: false
  alias Trivium.PostGIS.Repo

  # SELECT 
  # ST_X (ST_ClosestPoint (ST_Transform(r.way, 4326), point.way)),
  # ST_Y (ST_ClosestPoint (ST_Transform(r.way, 4326), point.way)),
  # ST_DistanceSphere(ST_ClosestPoint(ST_Transform (r.way, 4326), point.way), point.way)
  # FROM
  # planet_osm_line AS r,
  # (SELECT ST_SetSRID(ST_Point('-71.412436','41.822898'), 4326) AS way) AS point
  # ORDER BY 
  #  3 ASC
  # LIMIT 1;

  def snap_to_road(map) do
    query =
      "SELECT ST_X (ST_ClosestPoint (ST_Transform(r.way, 4326), point.way)) AS longitude, ST_Y (ST_ClosestPoint (ST_Transform(r.way, 4326), point.way)) AS latitude, ST_DistanceSphere(ST_ClosestPoint(ST_Transform (r.way, 4326), point.way), point.way) AS distance FROM planet_osm_line AS r, (SELECT ST_SetSRID(ST_Point('#{
        map["lon"]
      }','#{map["lat"]}'), 4326) AS way) AS point ORDER BY 3 ASC LIMIT 1;"

    case Repo.query(query) do
      # {:ok, %Postgrex.Result{columns: columns, rows: rows}} ->
      #   [row | rows] = rows
      {:ok, result} ->
        {:ok, DBUtils.result_to_map_list(result)}

      {:error, _} ->
        {:error, "dunno"}
    end
  end

  def get_speed_limit(map) do
    latitude = map["lat"]
    longitude = map["lon"]
    limit = 1 || map["limit"] || 1
    query = "SELECT
    ST_DistanceSphere(ST_ClosestPoint(ST_Transform (r.way, 4326), point.way), point.way) AS distance,
    ST_X (ST_ClosestPoint (ST_Transform(r.way, 4326), point.way)) AS longitude,
    ST_Y (ST_ClosestPoint (ST_Transform(r.way, 4326), point.way)) AS latitude,
    r.tags->'maxspeed' AS maxspeed,
    r.tags->'maxspeed:advisory' AS maxspeed_advisory,
    r.name,
    r.ref,
    r.tags,
    r.highway AS type,
    r.osm_id AS id
    FROM
    planet_osm_line AS r,
    (SELECT ST_SetSRID(ST_Point('#{longitude}','#{latitude}'), 4326) AS way) AS point
    WHERE r.highway IS NOT NULL
    AND r.highway IN ('motorway', 'trunk', 'primary', 'secondary', 'tertiary', 'unclassified', 'residential', 'motorway_link', 'trunk_link', 'primary_link', 'secondary_link', 'tertiary_link', 'living_street', 'service', 'pedestrian', 'road') 
    ORDER BY 1 ASC
    LIMIT #{limit};"

    case Repo.query(query) do
      {:ok, result} ->
        {:ok, DBUtils.result_to_map_list(result)}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  # def list_tokens(conn) do
  #   user = Pow.Plug.current_user(conn)
  #   #   from(r in Resource, preload: [foo: ^not_deleted(Foo), bar: ^not_deleted(Bar)])
  #   # |> Repo.all()

  #   from(t in Token, where: [user_id: ^user.id])
  #   |> not_deleted()
  #   |> Repo.all()
  # end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  # def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_token(conn, attrs \\ %{}) do
  #   user = conn |> Pow.Plug.current_user() |> IO.inspect(label: "create_token user")

  #   %Token{
  #     user_id: user.id,
  #     token:
  #       :crypto.hmac(
  #         :sha,
  #         "herpaderp",
  #         :crypto.strong_rand_bytes(6) |> Base.encode16(case: :lower)
  #       )
  #       |> Base.encode16(case: :lower)
  #   }
  #   |> IO.inspect(label: "about to create token")
  #   |> Token.changeset(attrs)
  #   |> Repo.insert()
  # end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def update_token(%Token{} = token, attrs) do
  #   token
  #   |> Token.changeset(attrs)
  #   |> Repo.update()
  # end

  @doc """
  Deletes a Token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  # def delete_token(%Token{} = token) do
  #   token
  #   |> Token.delete()
  #   |> Repo.update()
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{source: %Token{}}

  """
  # def change_token(%Token{} = token) do
  #   Token.changeset(token, %{})
  # end

  # defp not_deleted(query) do
  #   from(q in query, where: is_nil(q.deleted_at))
  # end
end
