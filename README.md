# UnblockMeSolver

**TODO: Add description**

## Usage

Prefix all commands with

```bash
docker run -it --rm -u $(id -u ${USER}):$(id -g ${USER}) -v "$PWD":/usr/src/app -w /usr/src/app elixir
```

For example

To run the tests

```bash
docker run -it --rm -u $(id -u ${USER}):$(id -g ${USER}) -v "$PWD":/usr/src/app -w /usr/src/app elixir mix test
```

Output:
```
```

Start by running

```bash
UID=${UID} GID=${GID} docker-compose up
```

Run commands by prefixing

```bash
UID=${UID} GID=${GID} docker-compose exec app
```

For example. To run the tests
```bash
UID=${UID} GID=${GID} docker-compose exec app mix test
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `unblock_me_solver` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:unblock_me_solver, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/unblock_me_solver](https://hexdocs.pm/unblock_me_solver).

