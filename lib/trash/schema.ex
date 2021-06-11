defmodule Trash.Schema do
  @moduledoc """
  Provides functions for integrating `Trash` with `Ecto.Schema`.

  ## Example

      defmodule MyApp.Post do
        use Ecto.Schema
        use Trash.Schema

        schema "posts" do
          field(:title, :string)
          trashable_fields()
        end
      end

  """

  @doc """
  Imports functions from `Trash.Schema`.

  Currently no options are available.
  """
  @spec __using__(options :: list()) :: Macro.t()
  defmacro __using__([]) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
  Declares fields on `Ecto.Schema` necessary for `Trash`.

  This is a macro that can be used inside of an `Ecto.Schema.schema/2` block to
  add the necessary fields.

  ## Fields

  - `discarded_at` - `:utc_datetime`
  - `discarded?` - `:boolean` (virtual)

  Note: under normal circumstances, `discarded?` will be `nil` since it's not
  possible to load a virtual field in Ecto. Instead, use
  `Trash.Query.select_trashable/1` to hydrate this field with a computed value
  from the database.
  """
  @spec trashable_fields() :: Macro.t()
  defmacro trashable_fields do
    quote do
      Ecto.Schema.field(:discarded_at, :utc_datetime)
      Ecto.Schema.field(:discarded?, :boolean, virtual: true)
    end
  end
end
