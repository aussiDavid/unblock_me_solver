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
  Determines if a block can be moved right and returns a tuple {status, updated_problem}.
  status will be :ok when the move is successful, otherwise :error

  ## Examples

      iex> UnblockMeSolver.Move.right_in_row_safely([
      ...>  ['C', 'C', nil, nil],
      ...>  ['A', 'A', nil, nil],
      ...>  ['D', 'D', nil, nil],
      ...>], 'A')
      {:ok, [
        ['C', 'C', nil, nil],
        [nil, 'A', 'A', nil],
        ['D', 'D', nil, nil],
      ]}

      iex> UnblockMeSolver.Move.right_in_row_safely([
      ...>  ['A', 'A', 'B'],
      ...>  [nil, nil, 'B'],
      ...>  [nil, nil, nil],
      ...>], 'A')
      {:error, nil}
  """
  def right_in_row_safely(problem, block) do
    blocked? = problem
    |> Enum.find(fn row -> Enum.any?(row, fn x -> x == block end) end)
    |> Enum.reverse
    |> Enum.take_while(fn x -> x != block end)
    |> Enum.any?(fn x -> x != nil end)

    if blocked? do
      {:error, nil}
    else
      {:ok, Move.right_in_row(problem, block)}
    end
  end

  @doc """
  Finds and moves a block right by 1 in a problem

  ## Examples

      iex> UnblockMeSolver.Move.right_in_row([
      ...>  ['C', 'C', nil, nil],
      ...>  ['A', 'A', nil, nil],
      ...>  ['D', 'D', nil, nil],
      ...>], 'A')
      [
        ['C', 'C', nil, nil],
        [nil, 'A', 'A', nil],
        ['D', 'D', nil, nil],
      ]
  """
  def right_in_row(problem, block) do
    problem
    |> Enum.map(fn row -> 
      if Enum.any?(row, fn x -> x == block end) do
        Move.right(row, block)
      else
        row
      end
    end)
  end

  @doc """
  Moves a block right by 1

  ## Examples

      iex> UnblockMeSolver.Move.right(['A', 'A', nil], 'A')
      [nil, 'A', 'A']

      iex> UnblockMeSolver.Move.right([nil, 'A', 'A', nil], 'A')
      [nil, nil, 'A', 'A']

  """
  def right(row, block) do
    row
    |> Move.stretch_right(block)
    |> Move.shrink_right(block)
  end

  @doc """
  Copies the last block to the adjacent-right cell

  ## Examples

      iex> UnblockMeSolver.Move.stretch_right(['A', 'A', nil], 'A')
      ['A', 'A', 'A']

  """
  def stretch_right(row, block) do
    blocks = Enum.filter(row, fn x -> x == block end)
    all_but_the_first_part = Enum.drop_while(row, fn x -> x != block end)
    last_part = Enum.drop_while(all_but_the_first_part, fn x -> x == block end)

    Enum.take_while(row, fn x -> x != block end)
    |> Enum.concat(blocks)
    |> Enum.concat([block])
    |> Enum.concat(Enum.drop(last_part, 1))
  end

  @doc """
  Removes the first occurance of a block

  ## Examples

      iex> UnblockMeSolver.Move.shrink_right(['A', 'A', 'A'], 'A')
      [nil, 'A', 'A']

  """
  def shrink_right(row, block) do
    blocks = Enum.filter(row, fn x -> x == block end)
    all_but_the_first_part = Enum.drop_while(row, fn x -> x != block end)
    last_part = Enum.drop_while(all_but_the_first_part, fn x -> x == block end)

    row
    |> Enum.take_while(fn x -> x != block end)
    |> Enum.concat([nil])
    |> Enum.concat(Enum.drop(blocks, 1))
    |> Enum.concat(last_part)
  end

  def rotate_ccw(problem) do
    problem
    |> Enum.map(&Enum.reverse/1)
    |> Transpose.transpose()
  end

  def rotate_cw(problem) do
    problem
    |> Transpose.transpose()
    |> Enum.map(&Enum.reverse/1)
  end
end
