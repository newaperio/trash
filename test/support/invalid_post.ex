defmodule Trash.Test.InvalidPost do
  @moduledoc false
  use Ecto.Schema
  use Trash.Schema

  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:author, :string)
    trashable_fields()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :author])
    |> validate_required(:author)
  end
end
