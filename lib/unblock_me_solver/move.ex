defmodule UnblockMeSolver.Move do
  alias UnblockMeSolver.Move

  @moduledoc false

  @doc """
  Determines if the problem is solvable
  A problem is solvable when there are empty spaces to the right of the solution block ['A', 'A']

  ## Examples

      iex> UnblockMeSolver.Move.solvable?([
      ...>  ['B', 'B', nil, nil, nil],
      ...>  ['C', 'C', nil, nil, nil],
      ...>  ['A', 'A', nil, nil, nil],
      ...>  ['D', 'D', nil, nil, nil],
      ...>  ['E', 'E', nil, nil, nil],
      ...>])
      true
  """
  def solvable?(problem) do
    problem
    |> Move.extract_solution_row()
    |> Enum.drop_while(fn x -> x != 'A' end)
    |> Enum.filter(fn x -> x != 'A' end)
    |> Enum.all?(fn x -> x == nil end)
  end

  @doc """
  Determines if the problem is solved by checking if the solution block is on the right most column

  ## Examples

      iex> UnblockMeSolver.Move.solved?([['A', 'A']], 'A')
      true

      iex> UnblockMeSolver.Move.solved?([['A', 'A', nil]], 'A')
      false

  """
  def solved?(problem, block) do
    problem
    |> Enum.find([], fn row -> Enum.any?(row, fn x -> x == block end) end)
    |> Enum.reverse
    |> Enum.at(0) == block
  end

  @doc """
  Extracts the middle row from a problem

  ## Examples

      iex> UnblockMeSolver.Move.extract_solution_row([
      ...>  ['B', 'B', nil, nil, nil],
      ...>  ['C', 'C', nil, nil, nil],
      ...>  ['A', 'A', nil, nil, nil],
      ...>  ['D', 'D', nil, nil, nil],
      ...>  ['E', 'E', nil, nil, nil],
      ...>])
      ['A', 'A', nil, nil, nil]

  """
  def extract_solution_row(problem) do
    index = (length(problem) / 2) |> floor

    case Enum.fetch(problem, index) do
      {:ok, row} -> row
      _ -> []
    end
  end

  @doc """
  Moves a block in the directation and returns a tuple
  {blocked_block, updated_problem} of the block in the way
  (nil if no block is in the way) and the updated problem
  (assuming it was succesful)

  ## Examples

      iex> UnblockMeSolver.Move.with_next([
      ...>  ['C', 'C', nil],
      ...>  ['A', 'A', nil],
      ...>  ['D', 'D', nil],
      ...>], :right, 'A')
      {nil, [
        ['C', 'C', nil],
        [nil, 'A', 'A'],
        ['D', 'D', nil],
      ]}

      iex> UnblockMeSolver.Move.with_next([
      ...>  ['A', 'A', 'B'],
      ...>  [nil, nil, 'B'],
      ...>  [nil, nil, nil],
      ...>], :right, 'A')
      {'B', [
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
        [nil, nil, nil],
      ]}
  """
  def with_next(problem, direction, block) do
    case direction do
      :right -> Move.Helper.right_with_next(problem, block)
      :down -> Move.Helper.down_with_next(problem, block)
      :up -> Move.Helper.up_with_next(problem, block)
      :left -> Move.Helper.left_with_next(problem, block)
      _ -> raise "Can not move in the direction #{direction}"
    end
  end

  @doc """
  Returns a the direction of the block in a problem
  I.e. :horizontal, :vertical. nil if otherwise

  ## Examples

      iex> UnblockMeSolver.Move.direction([[nil, 'A', 'A', nil]], 'A')
      :horizontal

      iex> UnblockMeSolver.Move.direction([[nil], ['A'], ['A'], [nil]], 'A')
      :vertical

  """
  def direction(problem, block) do
    has_row? = fn row ->
      Enum.count(row, fn x -> x == block end) > 1
    end

    cond do
      Enum.any?(problem, has_row?) -> :horizontal
      Enum.any?(Move.Helper.rotate_cw(problem), has_row?) -> :vertical
      true -> nil
    end
  end
end
