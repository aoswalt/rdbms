defmodule Exdb do
  @moduledoc """
  Documentation for Exdb.
  """

  def load_db() do
    %{
      "album" => File.stream!("./priv/album.csv") |> CSV.decode,
      "customer" => File.stream!("./priv/customer.csv") |> CSV.decode,
      "employee" => File.stream!("./priv/employee.csv") |> CSV.decode,
      "genre" => File.stream!("./priv/genre.csv") |> CSV.decode,
      "invoice" => File.stream!("./priv/invoice.csv") |> CSV.decode,
      "invoiceline" => File.stream!("./priv/invoiceline.csv") |> CSV.decode,
      "mediatype" => File.stream!("./priv/mediatype.csv") |> CSV.decode,
      "playlist" => File.stream!("./priv/playlist.csv") |> CSV.decode,
      "playlisttrack" => File.stream!("./priv/playlisttrack.csv") |> CSV.decode,
      "track" => File.stream!("./priv/track.csv") |> CSV.decode,
    }
  end

  @doc """
    SELECT Name
    FROM Genre
    WHERE GenreId = 6

    Blues
  """
  def simple_query(view_field, table, where_field, value) do
    load_db()
    |> Map.get(table)
    |> map_rows
    |> Stream.filter(&(Map.get(&1, where_field) == value))
    |> Stream.map(&(Map.get(&1, view_field)))
  end

  def test() do
    simple_query("Name", "genre", "GenreId", "6")
    |> Enum.to_list
    |> IO.inspect
  end

  def map_rows(headed_list) do
    headers = Stream.take(headed_list, 1) |> Stream.flat_map(&(&1))

    Stream.drop(headed_list, 1)
    |> Stream.map(&(Stream.zip(headers, &1)))
    |> Stream.map(&Map.new/1)
  end

end
