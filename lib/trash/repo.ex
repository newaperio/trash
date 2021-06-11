defmodule Trash.Repo do
  @moduledoc """
  Provides functions for discarding and keeping records and querying for them
  via `Ecto.Repo` functions.
  """
  require Ecto.Query

  alias Ecto.Query
  alias Ecto.Queryable
  alias Ecto.Changeset
  alias Trash.Query, as: TrashQuery

  @doc """
  Imports functions from `Trash.Repo`.

  It's not required to `use` this module in order to use `Trash`. Doing so
  will import shorthand functions into your app's `Repo` module with the repo
  implicitly passed. It's a bit more convenient, but the functions are public
  on `Trash.Repo`, so if preferred they can be called directly.

  ```
  # Shorthand with `use`
  MyRepo.all_discarded(Post)

  # Long form without
  Trash.Repo.all_discarded(Post, [], MyRepo)
  ```

  ## Options

  - `repo` - A module reference to an `Ecto.Repo`; raises `ArgumentError` if
  missing

  ## Examples

      defmodule MyApp.Repo
        use Ecto.Schema
        use Trash.Schema, repo: __MODULE__
      end

  """

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
  # credo:disable-for-this-file Credo.Check.Consistency.ParameterPatternMatching

  @spec __using__(opts :: list()) :: Macro.t()
  defmacro __using__(opts) do
    quote do
      import unquote(__MODULE__)

      @__trash_repo__ unquote(compile_config(opts))

      @doc """
      Fetches all entries matching the given query that have been discarded.

      ## Examples

          iex> MyRepo.all_discarded(Post)
          [%Post{
            title: "Hello World",
            discarded_at: %DateTime{},
            discarded?: nil
          }]

      """
      @spec all_discarded(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: [Ecto.Schema.t()]
      def all_discarded(queryable, opts \\ []) do
        all_discarded(queryable, opts, @__trash_repo__)
      end

      @doc """
      Fetches all entries matching the given query that have been kept.

      ## Examples

          iex> MyRepo.all_kept(Post)
          [%Post{title: "Hello World", discarded_at: nil, discarded?: nil}]

      """
      @spec all_kept(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: [Ecto.Schema.t()]
      def all_kept(queryable, opts \\ []) do
        all_kept(queryable, opts, @__trash_repo__)
      end

      @doc """
      Updates a record as discarded.

      This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a
      struct is given a bare changeset is generated first.

      A change is added to the changeset to set `discarded_at` to
      `DateTime.utc_now/1`. It calls `repo.update/2` to finalize the changes.

      It returns `{:ok, struct}` if the struct has been successfully updated
      or `{:error, changeset}` if there was an error.

      ## Examples

          iex> Post.changeset(post, %{title: "[Archived] Hello, world"})
               |> MyRepo.discard()
          {:ok,
            %Post{title: "[Archived] Hello, world", discarded_at: %DateTime{}}}

      """
      @spec discard(changeset_or_schema :: Changeset.t() | Ecto.Schema.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Changeset.t()}
      def discard(changeset = %Changeset{}) do
        discard(changeset, @__trash_repo__)
      end

      def discard(%{__struct__: _} = struct) do
        discard(struct, @__trash_repo__)
      end

      @doc """
      Updates a record as discarded.

      This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
      is given a bare changeset is generated first.

      A change is added to the changeset to set `discarded_at` to
      `DateTime.utc_now/1`. It calls `repo.update/2` to finalize the changes.

      Raises `Ecto.InvalidChangesetError` if the changeset is invalid.

      Note: since an `Ecto.Schema` struct can be passed which generates a bare
      changeset, this will never raise when given a struct.

      ## Examples

          iex> Post.changeset(post, %{title: "[Archived] Hello, world"})
               |> MyRepo.discard!
          %Post{title: "[Archived] Hello, world", discarded_at: %DateTime{}}

          iex> Post.changeset(post, %{}) |> MyRepo.discard!
          ** (Ecto.InvalidChangesetError)

      """
      @spec discard!(changeset_or_schema :: Changeset.t() | Ecto.Schema.t()) ::
              Ecto.Schema.t()
      def discard!(changeset = %Changeset{}) do
        discard!(changeset, @__trash_repo__)
      end

      def discard!(%{__struct__: _} = struct) do
        discard!(struct, @__trash_repo__)
      end

      @doc """
      Checks if there exists an entry that matches the given query that has been
      discarded.

      Returns a boolean.

      ## Examples

          iex> MyRepo.discarded?(post)
          true

      """
      @spec discarded?(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: boolean
      def discarded?(queryable, opts \\ []) do
        discarded?(queryable, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single discarded result where the primary key matches the given
      `id`.

      Returns `nil` if no result was found.

      ## Examples

          iex> MyRepo.get_discarded(Post)
          %Post{
            title: "Hello World",
            discarded_at: %DateTime{},
            discarded?: nil
          }

      """
      @spec get_discarded(
              queryable :: Ecto.Queryable.t(),
              id :: term(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def get_discarded(queryable, id, opts \\ []) do
        get_discarded(queryable, id, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single discarded result where the primary key matches the given
      `id`.

      Raises `Ecto.NoResultsError` if no result was found.

      ## Examples

          iex> MyRepo.get_discarded!(Post, 1)
          %Post{
            title: "Hello World",
            discarded_at: %DateTime{},
            discarded?: nil
          }

          iex> MyRepo.get_discarded!(Post, 2)
          ** (Ecto.NoResultsError)

      """
      @spec get_discarded!(
              queryable :: Ecto.Queryable.t(),
              id :: term(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def get_discarded!(queryable, id, opts \\ []) do
        get_discarded!(queryable, id, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single discarded result from the query.

      Returns `nil` if no result was found or raises
      `Ecto.MultipleResultsError` if more than one entry.

      ## Examples

          iex> MyRepo.get_discarded_by(Post, [title: "Hello World"])
          %Post{title: "Hello World", discarded_at: %DateTime{}}

      """
      @spec get_discarded_by(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def get_discarded_by(queryable, clauses, opts \\ []) do
        get_discarded_by(queryable, clauses, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single discarded result from the query.

      Raises `Ecto.MultipleResultsError` if more than one result. Raises
      `Ecto.NoResultsError` if no result was found.

      ## Examples

          iex> MyRepo.get_discarded_by!(Post, [title: "Hello World"])
          %Post{title: "Hello World", discarded_at: %DateTime{}}

          iex> MyRepo.get_discarded_by!(Post, [title: "Unwritten"])
          ** (Ecto.NoResultsError)

      """
      @spec get_discarded_by!(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t()
      def get_discarded_by!(queryable, clauses, opts \\ []) do
        get_discarded_by!(queryable, clauses, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single kept result where the primary key matches the given `id`.

      Returns `nil` if no result was found.

      ## Examples

          iex> MyRepo.get_kept(Post, 1)
          %Post{title: "Hello World", discarded_at: nil}

      """
      @spec get_kept(
              queryable :: Ecto.Queryable.t(),
              id :: term(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def get_kept(queryable, id, opts \\ []) do
        get_kept(queryable, id, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single kept result where the primary key matches the given `id`.

      Raises `Ecto.NoResultsError` if no result was found.

      ## Examples

          iex> MyRepo.get_kept!(Post, 1)
          %Post{title: "Hello World", discarded_at: nil}

          iex> MyRepo.get_kept!(Post, 2)
          ** (Ecto.NoResultsError)

      """
      @spec get_kept!(
              queryable :: Ecto.Queryable.t(),
              id :: term(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def get_kept!(queryable, id, opts \\ []) do
        get_kept!(queryable, id, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single kept result from the query.

      Returns `nil` if no result was found or raises
      `Ecto.MultipleResultsError` if more than one entry.

      ## Examples

          iex> MyRepo.get_kept_by(Post, title: "Hello World")
          %Post{title: "Hello World", discarded_at: nil}

      """
      @spec get_kept_by(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def get_kept_by(queryable, clauses, opts \\ []) do
        get_kept_by(queryable, clauses, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single kept result from the query.

      Raises `Ecto.MultipleResultsError` if more than one result. Raises
      `Ecto.NoResultsError` if no result was found.

      ## Examples

          iex> MyRepo.get_kept_by!(Post, title: "Hello World")
          %Post{title: "Hello World", discarded_at: %DateTime{}}

          iex> MyRepo.get_kept_by!(Post, title: "Not Written")
          ** (Ecto.NoResultsError)

      """
      @spec get_kept_by!(
              queryable :: Ecto.Queryable.t(),
              clauses :: Keyword.t() | map,
              opts :: Keyword.t()
            ) :: Ecto.Schema.t()
      def get_kept_by!(queryable, clauses, opts \\ []) do
        get_kept_by!(queryable, clauses, opts, @__trash_repo__)
      end

      @doc """
      Checks if there exists an entry that matches the given query that has been
      kept.

      Returns a boolean.

      ## Examples

          iex> MyRepo.kept?(post)
          true

      """
      @spec kept?(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: boolean
      def kept?(queryable, opts \\ []) do
        kept?(queryable, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single discarded result from the query.

      Returns `nil` if no result was found or raises
      `Ecto.MultipleResultsError` if more than one entry.

      ## Examples

          iex> MyRepo.one_discarded(Post)
          %Post{title: "Hello World", discarded_at: %DateTime{}}

      """
      @spec one_discarded(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def one_discarded(queryable, opts \\ []) do
        one_discarded(queryable, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single discarded result from the query.

      Raises `Ecto.MultipleResultsError` if more than one result. Raises
      `Ecto.NoResultsError` if no result was found.

      ## Examples

          iex> MyRepo.one_discarded!(Post)
          %Post{title: "Hello World", discarded_at: %DateTime{}}

          iex> MyRepo.one_discarded!(Post)
          ** (Ecto.NoResultsError)

      """
      @spec one_discarded!(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t()
      def one_discarded!(queryable, opts \\ []) do
        one_discarded!(queryable, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single kept result from the query.

      Returns `nil` if no result was found or raises
      `Ecto.MultipleResultsError` if more than one entry.

      ## Examples

          iex> MyRepo.one_kept(Post)
          %Post{title: "Hello World", discarded_at: nil}

      """
      @spec one_kept(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t() | nil
      def one_kept(queryable, opts \\ []) do
        one_kept(queryable, opts, @__trash_repo__)
      end

      @doc """
      Fetches a single kept result from the query.

      Raises `Ecto.MultipleResultsError` if more than one result. Raises
      `Ecto.NoResultsError` if no result was found.

      ## Examples

          iex> MyRepo.one_kept!(Post)
          %Post{title: "Hello World", discarded_at: nil}

          iex> MyRepo.one_kept!(Post)
          ** (Ecto.NoResultsError)

      """
      @spec one_kept!(
              queryable :: Ecto.Queryable.t(),
              opts :: Keyword.t()
            ) :: Ecto.Schema.t()
      def one_kept!(queryable, opts \\ []) do
        one_kept!(queryable, opts, @__trash_repo__)
      end

      @doc """
      Updates a record as kept.

      This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
      is given a bare changeset is generated first.

      A change is added to the changeset to set `discarded_at` to `nil`. It calls
      `repo.update/2` to finalize the changes.

      It returns `{:ok, struct}` if the struct has been successfully updated or
      `{:error, changeset}` if there was an error.

      ## Examples

          iex> Post.changeset(post, %{title: "Hello, world"})
               |> MyRepo.restore()
          {:ok, %Post{title: "Hello, world", discarded_at: nil}}

      """
      @spec restore(changeset_or_schema :: Changeset.t() | Ecto.Schema.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Changeset.t()}
      def restore(changeset = %Changeset{}) do
        restore(changeset, @__trash_repo__)
      end

      def restore(%{__struct__: _} = struct) do
        restore(struct, @__trash_repo__)
      end

      @doc """
      Updates a record as kept.

      This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
      is given a bare changeset is generated first.

      A change is added to the changeset to set `discarded_at` to `nil`. It calls
      `repo.update/2` to finalize the changes.

      Raises `Ecto.InvalidChangesetError` if the changeset is invalid.

      Note: since an `Ecto.Schema` struct can be passed which generates a bare
      changeset, this will never raise when given a struct.

      ## Examples

          iex> Post.changeset(post, %{title: "[Archived] Hello, world"})
               |> MyRepo.restore!()
          %Post{title: "[Archived] Hello, world", discarded_at: nil}

          iex> Post.changeset(post, %{}) |> MyRepo.restore!()
          ** (Ecto.InvalidChangesetError)

      """
      @spec restore!(changeset_or_schema :: Changeset.t() | Ecto.Schema.t()) ::
              Ecto.Schema.t()
      def restore!(changeset = %Changeset{}) do
        restore!(changeset, @__trash_repo__)
      end

      def restore!(%{__struct__: _} = struct) do
        restore!(struct, @__trash_repo__)
      end
    end
  end

  @doc """
  Fetches all entries matching the given query that have been discarded.

  ## Examples

      iex> Trash.Repo.all_discarded(Post, [], MyApp.Repo)
      [%Post{title: "Hello World", discarded_at: %DateTime{}, discarded?: nil}]

  """
  @spec all_discarded(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: [Ecto.Schema.t()]
  def all_discarded(queryable, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.all(opts)
  end

  @doc """
  Fetches all entries matching the given query that have been kept.

  ## Examples

      iex> Trash.Repo.all_kept(Post, [], MyApp.Repo)
      [%Post{title: "Hello World", discarded_at: nil, discarded?: nil}]

  """
  @spec all_kept(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: [Ecto.Schema.t()]
  def all_kept(queryable, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.all(opts)
  end

  @doc """
  Updates a record as discarded.

  This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
  is given a bare changeset is generated first.

  A change is added to the changeset to set `discarded_at` to
  `DateTime.utc_now/1`. It calls `repo.update/2` to finalize the changes.

  It returns `{:ok, struct}` if the struct has been successfully updated or
  `{:error, changeset}` if there was an error.

  ## Examples

      iex> Post.changeset(post, %{title: "[Archived] Hello, world"})
           |> Trash.Repo.discard(MyApp.Repo)
      {:ok, %Post{title: "[Archived] Hello, world", discarded_at: %DateTime{}}}

  """
  @spec discard(
          changeset_or_schema :: Changeset.t() | Ecto.Schema.t(),
          repo :: atom
        ) :: {:ok, Ecto.Schema.t()} | {:error, Changeset.t()}
  def discard(changeset = %Changeset{}, repo) do
    changeset
    |> Changeset.put_change(
      :discarded_at,
      DateTime.truncate(DateTime.utc_now(), :second)
    )
    |> repo.update()
  end

  def discard(%{__struct__: _} = struct, repo) do
    struct
    |> Changeset.change()
    |> discard(repo)
  end

  @doc """
  Updates a record as discarded.

  This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
  is given a bare changeset is generated first.

  A change is added to the changeset to set `discarded_at` to
  `DateTime.utc_now/1`. It calls `repo.update/2` to finalize the changes.

  Raises `Ecto.InvalidChangesetError` if the changeset is invalid.

  Note: since an `Ecto.Schema` struct can be passed which generates a bare
  changeset, this will never raise when given a struct.

  ## Examples

      iex> Post.changeset(post, %{title: "[Archived] Hello, world"})
           |> Trash.Repo.discard!(MyApp.Repo)
      %Post{title: "[Archived] Hello, world", discarded_at: %DateTime{}}

      iex> Post.changeset(post, %{}) |> Trash.Repo.discard!(MyApp.Repo)
      ** (Ecto.InvalidChangesetError)

  """
  @spec discard!(
          changeset_or_schema :: Changeset.t() | Ecto.Schema.t(),
          repo :: atom
        ) :: Ecto.Schema.t()
  def discard!(changeset = %Changeset{}, repo) do
    case discard(changeset, repo) do
      {:ok, struct} ->
        struct

      {:error, changeset} ->
        raise Ecto.InvalidChangesetError,
          action: :discard,
          changeset: changeset
    end
  end

  def discard!(%{__struct__: _} = struct, repo) do
    {:ok, struct} = discard(struct, repo)
    struct
  end

  @doc """
  Checks if there exists an entry that matches the given query that has been
  discarded.

  Returns a boolean.

  ## Examples

      iex> Trash.Repo.discarded?(post, [], MyApp.Repo)
      true

  """
  @spec discarded?(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: boolean
  def discarded?(queryable, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.exists?(opts)
  end

  @doc """
  Fetches a single discarded result where the primary key matches the given
  `id`.

  Returns `nil` if no result was found.

  ## Examples

      iex> Trash.Repo.get_discarded(Post, 1, [], MyApp.Repo)
      %Post{}

  """
  @spec get_discarded(
          queryable :: Ecto.Queryable.t(),
          id :: term(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def get_discarded(queryable, id, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.get(id, opts)
  end

  @doc """
  Fetches a single discarded result where the primary key matches the given
  `id`.

  Raises `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> Trash.Repo.get_discarded!(Post, 1, [], MyApp.Repo)
      %Post{}

      iex> Trash.Repo.get_discarded!(Post, 2, [], MyApp.Repo)
      ** (Ecto.NoResultsError)

  """
  @spec get_discarded!(
          queryable :: Ecto.Queryable.t(),
          id :: term(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def get_discarded!(queryable, id, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.get!(id, opts)
  end

  @doc """
  Fetches a single discarded result from the query.

  Returns `nil` if no result was found or raises `Ecto.MultipleResultsError` if
  more than one entry.

  ## Examples

      iex> Trash.Repo.get_discarded_by(Post, [title: "Hello World"], [],
      MyApp.Repo)
      %Post{title: "Hello World", discarded_at: %DateTime{}}

  """
  @spec get_discarded_by(
          queryable :: Ecto.Queryable.t(),
          clauses :: Keyword.t() | map,
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def get_discarded_by(queryable, clauses, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.get_by(clauses, opts)
  end

  @doc """
  Fetches a single discarded result from the query.

  Raises `Ecto.MultipleResultsError` if more than one result. Raises
  `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> Trash.Repo.get_discarded_by!(Post, [title: "Hello World"], [],
      MyApp.Repo)
      %Post{title: "Hello World", discarded_at: %DateTime{}}

      iex> Trash.Repo.get_discarded_by!(Post, [title: "Hello World"], [],
      MyApp.Repo)
      ** (Ecto.NoResultsError)

  """
  @spec get_discarded_by!(
          queryable :: Ecto.Queryable.t(),
          clauses :: Keyword.t() | map,
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t()
  def get_discarded_by!(queryable, clauses, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.get_by!(clauses, opts)
  end

  @doc """
  Fetches a single kept result where the primary key matches the given `id`.

  Returns `nil` if no result was found.

  ## Examples

      iex> Trash.Repo.get_kept(Post, 1, [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: nil}

  """
  @spec get_kept(
          queryable :: Ecto.Queryable.t(),
          id :: term(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def get_kept(queryable, id, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.get(id, opts)
  end

  @doc """
  Fetches a single kept result where the primary key matches the given `id`.

  Raises `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> Trash.Repo.get_kept!(Post, 1, [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: nil}

      iex> Trash.Repo.get_kept!(Post, 2, [], MyApp.Repo)
      ** (Ecto.NoResultsError)

  """
  @spec get_kept!(
          queryable :: Ecto.Queryable.t(),
          id :: term(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def get_kept!(queryable, id, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.get!(id, opts)
  end

  @doc """
  Fetches a single kept result from the query.

  Returns `nil` if no result was found or raises `Ecto.MultipleResultsError` if
  more than one entry.

  ## Examples

      iex> Trash.Repo.get_kept_by(Post, title: "Hello World", [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: nil}

  """
  @spec get_kept_by(
          queryable :: Ecto.Queryable.t(),
          clauses :: Keyword.t() | map,
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def get_kept_by(queryable, clauses, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.get_by(clauses, opts)
  end

  @doc """
  Fetches a single kept result from the query.

  Raises `Ecto.MultipleResultsError` if more than one result. Raises
  `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> Trash.Repo.get_kept_by!(Post, title: "Hello World", [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: %DateTime{}}

      iex> Trash.Repo.get_kept_by!(Post, title: "Not Written", [], MyApp.Repo)
      ** (Ecto.NoResultsError)

  """
  @spec get_kept_by!(
          queryable :: Ecto.Queryable.t(),
          clauses :: Keyword.t() | map,
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t()
  def get_kept_by!(queryable, clauses, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.get_by!(clauses, opts)
  end

  @doc """
  Checks if there exists an entry that matches the given query that has been
  kept.

  Returns a boolean.

  ## Examples

      iex> Trash.Repo.kept?(post, [], MyApp.Repo)
      true

  """
  @spec kept?(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: boolean
  def kept?(queryable, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.exists?(opts)
  end

  @doc """
  Fetches a single discarded result from the query.

  Returns `nil` if no result was found or raises `Ecto.MultipleResultsError` if
  more than one entry.

  ## Examples

      iex> Trash.Repo.one_discarded(Post, [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: %DateTime{}}

  """
  @spec one_discarded(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def one_discarded(queryable, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.one(opts)
  end

  @doc """
  Fetches a single discarded result from the query.

  Raises `Ecto.MultipleResultsError` if more than one entry.  Raises
  `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> Trash.Repo.one_discarded!(Post, [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: %DateTime{}}

      iex> Trash.Repo.one_discarded!(Post, [], MyApp.Repo)
      ** (Ecto.NoResultsError)

  """
  @spec one_discarded!(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t()
  def one_discarded!(queryable, opts \\ [], repo) do
    queryable
    |> discarded_queryable()
    |> repo.one!(opts)
  end

  @doc """
  Fetches a single kept result from the query.

  Returns `nil` if no result was found or raises `Ecto.MultipleResultsError` if
  more than one entry.

  ## Examples

      iex> Trash.Repo.one_kept(Post, [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: nil}

  """
  @spec one_kept(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t() | nil
  def one_kept(queryable, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.one(opts)
  end

  @doc """
  Fetches a single kept result from the query.

  Raises `Ecto.MultipleResultsError` if more than one entry.  Raises
  `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> Trash.Repo.one_kept!(Post, [], MyApp.Repo)
      %Post{title: "Hello World", discarded_at: nil}

      iex> Trash.Repo.one_kept!(Post, [], MyApp.Repo)
      ** (Ecto.NoResultsError)

  """
  @spec one_kept!(
          queryable :: Ecto.Queryable.t(),
          opts :: Keyword.t(),
          repo :: atom
        ) :: Ecto.Schema.t()
  def one_kept!(queryable, opts \\ [], repo) do
    queryable
    |> kept_queryable()
    |> repo.one!(opts)
  end

  @doc """
  Updates a record as kept.

  This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
  is given a bare changeset is generated first.

  A change is added to the changeset to set `discarded_at` to `nil`. It calls
  `repo.update/2` to finalize the changes.

  It returns `{:ok, struct}` if the struct has been successfully updated or
  `{:error, changeset}` if there was an error.

  ## Examples

      iex> Post.changeset(post, %{title: "Hello, world"})
           |> Trash.Repo.restore(MyApp.Repo)
      {:ok, %Post{title: "Hello, world", discarded_at: nil}}

  """
  @spec restore(
          changeset_or_schema :: Changeset.t() | Ecto.Schema.t(),
          repo :: atom
        ) :: {:ok, Ecto.Schema.t()} | {:error, Changeset.t()}
  def restore(changeset = %Changeset{}, repo) do
    changeset
    |> Changeset.put_change(:discarded_at, nil)
    |> repo.update()
  end

  def restore(%{__struct__: _} = struct, repo) do
    struct
    |> Changeset.change()
    |> restore(repo)
  end

  @doc """
  Updates a record as kept.

  This takes either an `Ecto.Changeset` or an `Ecto.Schema` struct. If a struct
  is given a bare changeset is generated first.

  A change is added to the changeset to set `discarded_at` to `nil`. It calls
  `repo.update/2` to finalize the changes.

  Raises `Ecto.InvalidChangesetError` if the changeset is invalid.

  Note: since an `Ecto.Schema` struct can be passed which generates a bare
  changeset, this will never raise when given a struct.

  ## Examples

      iex> Post.changeset(post, %{title: "[Archived] Hello, world"})
           |> Trash.Repo.restore!(MyApp.Repo)
      %Post{title: "[Archived] Hello, world", discarded_at: nil}

      iex> Post.changeset(post, %{}) |> Trash.Repo.restore!(MyApp.Repo)
      ** (Ecto.InvalidChangesetError)

  """
  @spec restore!(
          changeset_or_schema :: Changeset.t() | Ecto.Schema.t(),
          repo :: atom
        ) :: Ecto.Schema.t()
  def restore!(changeset = %Changeset{}, repo) do
    case restore(changeset, repo) do
      {:ok, struct} ->
        struct

      {:error, changeset} ->
        raise Ecto.InvalidChangesetError,
          action: :restore,
          changeset: changeset
    end
  end

  def restore!(%{__struct__: _} = struct, repo) do
    {:ok, struct} = restore(struct, repo)
    struct
  end

  defp compile_config(opts) do
    case Keyword.fetch(opts, :repo) do
      {:ok, value} ->
        value

      :error ->
        raise ArgumentError, "missing :repo option on use Trash.Repo"
    end
  end

  defp discarded_queryable(queryable) do
    queryable
    |> Queryable.to_query()
    |> Query.from()
    |> TrashQuery.where_discarded()
  end

  defp kept_queryable(queryable) do
    queryable
    |> Queryable.to_query()
    |> Query.from()
    |> TrashQuery.where_kept()
  end
end
