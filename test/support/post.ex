defmodule Trash.Test.Post do
  @moduledoc false
  use Ecto.Schema
  use Trash.Schema

  schema "posts" do
    field(:title, :string)
    trashable_fields()
  end
end
