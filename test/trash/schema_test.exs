defmodule Trash.SchemaTest do
  use ExUnit.Case

  alias Trash.Test.Post

  test "trashable_fields/0 adds trashable fields" do
    post = %Post{}

    assert post.discarded? == nil
    assert post.discarded_at == nil
  end
end
