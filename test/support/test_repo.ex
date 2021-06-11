defmodule Trash.Test.Repo do
  @moduledoc false
  use Trash.Repo, repo: __MODULE__

  @spec all(any, any) :: {:ok, :all}
  def all(_queryable, _opts) do
    {:ok, :all}
  end

  @spec exists?(any, any) :: {:ok, :exists?}
  def exists?(_queryable, _opts) do
    {:ok, :exists?}
  end

  @spec get(any, any, any) :: {:ok, :get, any}
  def get(_queryable, id, _opts) do
    {:ok, :get, id}
  end

  @spec get!(any, any, any) :: {:ok, :get!, any}
  def get!(_queryable, id, _opts) do
    {:ok, :get!, id}
  end

  @spec get_by(any, any, any) :: {:ok, :get_by, any}
  def get_by(_queryable, clauses, _opts) do
    {:ok, :get_by, clauses}
  end

  @spec get_by!(any, any, any) :: {:ok, :get_by!, any}
  def get_by!(_queryable, clauses, _opts) do
    {:ok, :get_by!, clauses}
  end

  @spec one(any, any) :: {:ok, :one}
  def one(_queryable, _opts) do
    {:ok, :one}
  end

  @spec one!(any, any) :: {:ok, :one!}
  def one!(_queryable, _opts) do
    {:ok, :one!}
  end

  @spec update(Ecto.Changeset.t()) :: {:error, Ecto.Changeset.t()} | {:ok, map}
  def update(changeset) do
    Ecto.Changeset.apply_action(changeset, :update)
  end
end
