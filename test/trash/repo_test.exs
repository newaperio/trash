defmodule Trash.RepoTest do
  use ExUnit.Case

  alias Trash.Test.InvalidPost
  alias Trash.Test.Post
  alias Trash.Test.Repo

  test "all_discarded/1 calls Repo.all" do
    assert {:ok, :all} = Repo.all_discarded(Post)
  end

  test "all_kept/1 calls Repo.all" do
    assert {:ok, :all} = Repo.all_kept(Post)
  end

  test "discard/1 updates struct" do
    post = %Post{title: "Hello, World"}

    assert {:ok, updated} = Repo.discard(post)
    assert updated.discarded_at
  end

  test "discard/1 with changeset updates struct" do
    post_changeset =
      %Post{title: "Hello, World"}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_change(:title, "Hello, Again")

    assert {:ok, updated} = Repo.discard(post_changeset)
    assert updated.discarded_at
  end

  test "discard!/1 with changeset raises error on failed update" do
    post_changeset =
      InvalidPost.changeset(%InvalidPost{title: "Hello, World"}, %{title: "Hello, Again"})

    assert_raise Ecto.InvalidChangesetError, fn ->
      Repo.discard!(post_changeset)
    end
  end

  test "discarded?/1 calls Repo.exists?" do
    assert {:ok, :exists?} = Repo.discarded?(Post)
  end

  test "get_discarded/2 calls Repo.get" do
    assert {:ok, :get, 123} = Repo.get_discarded(Post, 123)
  end

  test "get_discarded!/2 calls Repo.get!" do
    assert {:ok, :get!, 123} = Repo.get_discarded!(Post, 123)
  end

  test "get_discarded_by/2 calls Repo.get_by" do
    assert {:ok, :get_by, title: "Hello, World"} =
             Repo.get_discarded_by(Post, title: "Hello, World")
  end

  test "get_discarded_by!/2 calls Repo.get!" do
    assert {:ok, :get_by!, title: "Hello, World"} =
             Repo.get_discarded_by!(Post, title: "Hello, World")
  end

  test "get_kept/2 calls Repo.get" do
    assert {:ok, :get, 123} = Repo.get_kept(Post, 123)
  end

  test "get_kept!/2 calls Repo.get!" do
    assert {:ok, :get!, 123} = Repo.get_kept!(Post, 123)
  end

  test "get_kept_by/2 calls Repo.get_by" do
    assert {:ok, :get_by, title: "Hello, World"} = Repo.get_kept_by(Post, title: "Hello, World")
  end

  test "get_kept_by!/2 calls Repo.get!" do
    assert {:ok, :get_by!, title: "Hello, World"} = Repo.get_kept_by!(Post, title: "Hello, World")
  end

  test "kept?/1" do
    assert {:ok, :exists?} = Repo.kept?(Post)
  end

  test "one_discarded/1 calls Repo.one" do
    assert {:ok, :one} = Repo.one_discarded(Post)
  end

  test "one_discarded!/1 calls Repo.one" do
    assert {:ok, :one!} = Repo.one_discarded!(Post)
  end

  test "one_kept/1 calls Repo.one" do
    assert {:ok, :one} = Repo.one_kept(Post)
  end

  test "one_kept!/1 calls Repo.one" do
    assert {:ok, :one!} = Repo.one_kept!(Post)
  end

  test "restore/1 updates struct" do
    post = %Post{title: "Hello, World", discarded_at: DateTime.utc_now()}

    assert {:ok, updated} = Repo.restore(post)
    refute updated.discarded_at
  end

  test "restore/1 with changeset updates struct" do
    post_changeset =
      %Post{title: "Hello, World", discarded_at: DateTime.utc_now()}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_change(:title, "Hello, Again")

    assert {:ok, updated} = Repo.restore(post_changeset)
    refute updated.discarded_at
  end

  test "restore!/1 with changeset raises error on failed update" do
    post_changeset =
      InvalidPost.changeset(%InvalidPost{title: "Hello, World"}, %{title: "Hello, Again"})

    assert_raise Ecto.InvalidChangesetError, fn ->
      Repo.restore!(post_changeset)
    end
  end
end
