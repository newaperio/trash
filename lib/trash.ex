defmodule Trash do
  @moduledoc """
  Trash helps manage soft-deleting `Ecto.Schema`s by providing convenience
  functions to update and query for discarded and kept records.

  ## Terminology

  Trash uses a few terms throughout to indicate the state of a record. Here's
  some quick definitions:

  - **Soft-deletion**: removing a record by updating an attribute instead of
  issuing a SQL `DELETE`
  - **Discarded**: a record that has been soft-deleted
  - **Kept**: a record that has not been soft-deleted
  - **Restore**: reverse a soft-deletion to keep a record
  """
end
