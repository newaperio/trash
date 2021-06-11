defmodule Trash.Query do
  @moduledoc """
  Provides query methods for working with records that implement `Trash`.

  Schemas should first include `Trash.Schema` and/or manually add the necessary
  fields for these to work.
  """
  require Ecto.Query

  alias Ecto.Query
  alias Ecto.Queryable

  @doc """
  Adds trashable fields to select.

  This ensures that both trashable fields are included in the select statement
  by using `Ecto.Query.select_merge/3` to merge in the fields.

  For a list of the current trashable fields, see
  `Trash.Schema.trashable_fields/0`.

  This loads `discarded_at` from the database and computes the boolean for
  `discarded?` from the SQL expression `discarded_at IS NOT NULL`.

  Note: Since `discarded?` is a virtual field, without using this function,
  it'll be `nil` by default.

  ## Examples

      iex> Trash.Query.select_trashable(Post) |> Repo.all()
      [%Post{title: "Hello World", discarded_at: %DateTime{}, discarded?: true}]

      iex> Trash.Query.select_trashable(Post) |> Repo.all()
      [%Post{title: "Hello World", discarded_at: nil, discarded?: false}]

  """
  @spec select_trashable(queryable :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def select_trashable(queryable) do
    queryable
    |> Queryable.to_query()
    |> Query.select_merge([t], %{
      discarded_at: t.discarded_at,
      discarded?: not is_nil(t.discarded_at)
    })
  end

  @doc """
  Adds a where clause for returning discarded records.

  This adds a where clause equivalent to the SQL expression `discarded_at IS NOT
  NULL` which denotes a record that has been discarded.

  ## Examples

      iex> Trash.Query.where_discarded(Post) |> Repo.all()
      [%Post{title: "Hello World", discarded_at: %DateTime{}, discarded?: nil}]

  """
  @spec where_discarded(queryable :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def where_discarded(queryable) do
    queryable
    |> Queryable.to_query()
    |> Query.where([t], not is_nil(t.discarded_at))
  end

  @doc """
  Adds a where clause for returning kept records.

  This adds a where clause equivalent to the SQL expression `discarded_at IS
  NULL` which denotes a record that has been kept.

  ## Examples

      iex> Trash.Query.where_kept(Post) |> Repo.all()
      [%Post{title: "Hello World", discarded_at: nil, discarded?: nil}]

  """
  @spec where_kept(queryable :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def where_kept(queryable) do
    queryable
    |> Queryable.to_query()
    |> Query.where([t], is_nil(t.discarded_at))
  end
end
