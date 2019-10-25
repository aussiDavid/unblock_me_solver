defmodule UnblockMeGenerator do
  @moduledoc """
  Documentation for UnblockMeGenerator
  Generates UnblockMe problems.
  """

  @doc """
  Generates a 5 by 5 problem of blocks.

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
