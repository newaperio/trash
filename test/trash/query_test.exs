defmodule Trash.QueryTest do
  use ExUnit.Case

  alias Trash.Test.Post
  alias Trash.Query

  test "select_trashable/1 selects trashable fields" do
    query = Query.select_trashable(Post)

    assert query.select.expr == select_expr()
  end

  test "where_discarded/1 adds condition for discarded records" do
    query = Query.where_discarded(Post)

    assert length(query.wheres) == 1
    assert List.first(query.wheres).expr == discarded_expr()
  end

  test "where_kept/1 adds condition for kept records" do
    query = Query.where_kept(Post)

    assert length(query.wheres) == 1
    assert List.first(query.wheres).expr == kept_expr()
  end

  defp select_expr do
    {:merge, [],
     [
       {:&, [], [0]},
       {:%{}, [],
        [
          discarded_at: {{:., [], [{:&, [], [0]}, :discarded_at]}, [], []},
          discarded?:
            {:not, [],
             [
               {:is_nil, [], [{{:., [], [{:&, [], [0]}, :discarded_at]}, [], []}]}
             ]}
        ]}
     ]}
  end

  defp discarded_expr do
    {:not, [], [{:is_nil, [], [{{:., [], [{:&, [], [0]}, :discarded_at]}, [], []}]}]}
  end

  defp kept_expr do
    {:is_nil, [], [{{:., [], [{:&, [], [0]}, :discarded_at]}, [], []}]}
  end
end
