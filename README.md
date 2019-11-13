# UnblockMeSolver

A solver and problem generator for the UnblockMe puzzle game in Elixir


## Quickstart

You can run this in a Docker container using the [aussidavid/unblockmesovler_elixir](https://hub.docker.com/r/aussidavid/unblockmesovler_elixir) image

```bash
docker run -it --rm aussidavid/unblockmesovler_elixir:latest
```

Output:
```bash
Erlang/OTP 22 [erts-10.5.5] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Interactive Elixir (1.9.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> UnblockMeSolver.generate()
[
  [nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil],
  ['A', 'A', nil, nil, nil],
  [nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil]
]
iex(2)> UnblockMeSolver.generate() |> UnblockMeSolver.solve()
[{'A', :right, 1}, {'A', :right, 1}, {'A', :right, 1}]
iex(3)>
```

## Installation

The package can be installed by adding `unblock_me_solver` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:unblock_me_solver, "~> 1.0.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/unblock_me_solver](https://hexdocs.pm/unblock_me_solver).

