# ♻️  Trash

![](https://github.com/newaperio/trash/workflows/CI/badge.svg)

Simple soft deletes for Ecto

## Installation

Trash is available on [Hex](https://hex.pm/packages/trash).

This package can be installed by adding `trash` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:trash, "~> 0.1.0"}
  ]
end
```

## Usage

Check the [documentation](https://hexdocs.pm/trash) for complete details.

Trash helps manage soft-deleting `Ecto.Schema`s by providing convenience
functions to update and query for discarded and kept records.

### Terminology

Trash uses a few terms throughout to indicate the state of a record. Here are
some quick definitions:

- **Soft-deletion**: removing a record by updating an attribute instead of
  issuing a SQL `DELETE`
- **Discarded**: a record that has been soft-deleted
- **Kept**: a record that has not been soft-deleted
- **Restore**: reverse a soft-deletion to keep a record

### Getting Started

Trash is opt-in on individual `Ecto.Schema`s. To start marking schemas as
trashable, first add the required trashable fields:

```bash
mix ecto.gen.migration add_trashable_to_posts
```

```elixir
defmodule MyApp.Repo.Migrations.AddTrashableToPosts do
  use Ecto.Migration

  def change do
    alter(table(:posts)) do
      add(:discarded_at, :utc_datetime)
    end

    create(index(:posts, :discarded_at))
  end
end
```

Then declare the fields on your schema. You can do this manually or use the
convenience functions in `Trash.Schema`:

```elixir
defmodule MyApp.Posts.Post do
  use Ecto.Schema
  use Trash.Schema

  schema "posts" do
    field(:title, :string)
    trashable_fields()
  end
end
```

Next, import `Trash` by using it in your `MyApp.Repo`.

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres

  use Trash.Repo, repo: __MODULE__
end
```

This generates shorthand functions with the repo implicitly passed. However,
it's not required to call `use`. If preferred you can call the functions
directly on `Trash.Repo` by passing the `Ecto.Repo` manually. It's a bit more
convenient with `use`, though.

```elixir
# Shorthand with `use`
MyRepo.all_discarded(Post)

# Long form without
MyRepo.all_discarded(Post, [], MyRepo)
```

### Soft-deleting and Restoring

The functions `discard` and `restore` will soft-delete and restore records,
respectively.

```elixir
alias MyApp.Posts
alias MyApp.Repo

post = Posts.get_last_post!

{:ok, post} = Repo.discard(post) # => %Post{discarded_at: %DateTime{}}
post = Repo.restore(post) # => %Post{discarded_at: nil}
```

These call out to the repo's `update` function. This means a SQL `UPDATE` has
been issued and the returned schema has updated trashable fields.

These functions also have bang versions, which unwrap the return tuple and raise
on error. Note: when passing a struct instead of a changeset, the bang versions
of these will never raise an error.

### Querying

Trash provides `discarded` and `kept` variations of the following `Ecto.Repo`
functions:

- `all`
- `exists?`
- `get`
- `get!`
- `get_by`
- `get_by!`
- `one`
- `one!`

The variations are postfixed with `discarded` and `kept` (with the exception of
`exists?` which is replaced by `discarded?` and `kept?`) and modify the
passed-in queryable to add a `WHERE` condition to only return discarded or kept
records.

Trash also provides helper `where` functions that can be used in conjunction
with `Ecto.Query`.

```elixir
import Ecto.Query
alias MyApp.Posts.Post

from(p in Post) |> Trash.Query.where_discarded() |> Repo.all()
```

There is also a function that merges in the trashable fields into the select
statement to always ensure they are returned. It also hydrates `discarded?` with
a computed `SQL` value.

```elixir
import Ecto.Query
alias MyApp.Posts.Post
alias MyApp.Repo

Post
|> Trash.Query.where_discarded()
|> Repo.all()
|> Trash.Query.select_trashable()
```

## Contributing

Contributions are welcome! To make changes, clone the repo, make sure tests
pass, and then open a PR on GitHub.

```console
git clone https://github.com/newaperio/trash.git
cd trash
mix deps.get
mix test
```

## License

Trash is Copyright © 2020 NewAperio. It is free software, and may be
redistributed under the terms specified in the [LICENSE](/LICENSE) file.

## About NewAperio

Trash is built by NewAperio, LLC.

NewAperio is a web and mobile design and development studio. We offer [expert
Elixir and Phoenix][services] development as part of our portfolio of services.
[Get in touch][contact] to see how our team can help you.

[services]: https://newaperio.com/services#elixir?utm_source=github
[contact]: https://newaperio.com/contact?utm_source=github

