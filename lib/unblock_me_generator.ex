defmodule UnblockMeGenerator do
  @moduledoc """
  UnblockMeGenerator generates UnblockMe problems in various configurations

  The function names provide a clear description of the difficulty of the problems

  example, a trivial problem:
      iex> UnblockMeGenerator.trivial()
      [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        ['A', 'A', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ]
  """

  @doc """
  Generates a 5 by 5 problem with 1 block.

  Idealy used as a test case, the solution block is unobstructed

  ## Examples

      iex> UnblockMeGenerator.trivial()
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
