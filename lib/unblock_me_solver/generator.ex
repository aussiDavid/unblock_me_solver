defmodule UnblockMeSolver.Generator do
  @moduledoc false

  @doc """
  Generates a 5 by 5 problem with 1 block.

  Idealy used as a test case, the solution block is unobstructed

  ## Examples

      iex> UnblockMeSolver.Generator.trivial()
      [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        ['A', 'A', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ]

  """
  def trivial do
    [
      [nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil],
      ['A', 'A', nil, nil, nil],
      [nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil]
    ]
  end
end
