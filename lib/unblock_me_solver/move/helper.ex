defmodule UnblockMeSolver.Move.Helper do
  alias UnblockMeSolver.Move.Helper

  @moduledoc false

  @doc """
  Moves a block right and returns a tuple {blocked_block, updated_problem}
  of the block in the way (nil if no block is in the way) and the updated
  problem (assuming it was succesful)

  ## Examples

      iex> UnblockMeSolver.Move.Helper.right_with_next([
      ...>  ['C', 'C', nil],
      ...>  ['A', 'A', nil],
      ...>  ['D', 'D', nil],
      ...>], 'A')
      {nil, [
        ['C', 'C', nil],
        [nil, 'A', 'A'],
        ['D', 'D', nil],
      ]}

      iex> UnblockMeSolver.Move.Helper.right_with_next([
      ...>  ['A', 'A', 'B'],
      ...>  [nil, nil, 'B'],
      ...>  [nil, nil, nil],
      ...>], 'A')
      {'B', [
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
        [nil, nil, nil],
      ]}

      iex> UnblockMeSolver.Move.Helper.right_with_next([['A', 'A']], 'A')
      {nil, [['A', 'A']]}
  """
  def right_with_next(problem, block) do
    cells_after_block = problem
    |> Enum.find(fn row -> Enum.any?(row, fn x -> x == block end) end)
    |> Enum.reverse
    |> Enum.take_while(fn x -> x != block end)
    |> Enum.reverse
    next_block = Enum.at(cells_after_block, 0)

    cond do
      Enum.count(cells_after_block) == 0 -> {nil, problem}
      next_block == nil -> {next_block, Helper.right_in_row(problem, block)}
      true -> {next_block, problem}
    end
  end

  @doc """
  Moves a block left and returns a tuple {blocked_block, updated_problem}
  of the block in the way (nil if no block is in the way) and the updated
  problem (assuming it was succesful)

  ## Examples

      iex> UnblockMeSolver.Move.Helper.left_with_next([
      ...>  [nil, 'C', 'C'],
      ...>  [nil, 'A', 'A'],
      ...>  [nil, 'D', 'D'],
      ...>], 'A')
      {nil, [
        [nil, 'C', 'C'],
        ['A', 'A', nil],
        [nil, 'D', 'D'],
      ]}

      # iex> UnblockMeSolver.Move.Helper.left_with_next([
      # ...>  ['A', 'A', nil],
      # ...>  [nil, nil, nil],
      # ...>  [nil, nil, nil],
      # ...>], 'A')
      # {nil, [
      #   ['A', 'A', nil],
      #   [nil, nil, nil],
      #   [nil, nil, nil],
      # ]}
  """
  def left_with_next(problem, block) do
    {next_block, rotated_problem} = problem
    |> Helper.rotate_ccw
    |> Helper.rotate_ccw
    |> Helper.right_with_next(block)

    {
      next_block,
      rotated_problem
      |> Helper.rotate_cw
      |> Helper.rotate_cw
    }
  end

  @doc """
  Moves a block down and returns a tuple {blocked_block, updated_problem}
  of the block in the way (nil if no block is in the way) and the updated
  problem (assuming it was succesful)

  ## Examples

      iex> UnblockMeSolver.Move.Helper.down_with_next([
      ...>  ['A'],
      ...>  ['A'],
      ...>  [nil],
      ...>], 'A')
      {nil, [
        [nil],
        ['A'],
        ['A'],
      ]}

      iex> UnblockMeSolver.Move.Helper.down_with_next([
      ...>  ['A', nil],
      ...>  ['A', nil],
      ...>  ['B', 'B'],
      ...>], 'A')
      {'B', [
        ['A', nil],
        ['A', nil],
        ['B', 'B'],
      ]}
  """
  def down_with_next(problem, block) do
    {next_block, rotated_problem} = problem
    |> Helper.rotate_ccw
    |> Helper.right_with_next(block)

    {
      next_block,
      rotated_problem
      |> Helper.rotate_cw
    }
  end

  @doc """
  Moves a block up and returns a tuple {blocked_block, updated_problem}
  of the block in the way (nil if no block is in the way) and the updated
  problem (assuming it was succesful)

  ## Examples

      iex> UnblockMeSolver.Move.Helper.up_with_next([
      ...>  [nil],
      ...>  ['A'],
      ...>  ['A'],
      ...>], 'A')
      {nil, [
        ['A'],
        ['A'],
        [nil],
      ]}

      iex> UnblockMeSolver.Move.Helper.up_with_next([
      ...>  ['B', 'B'],
      ...>  ['A', nil],
      ...>  ['A', nil],
      ...>], 'A')
      {'B', [
        ['B', 'B'],
        ['A', nil],
        ['A', nil],
      ]}
  """
  def up_with_next(problem, block) do
    { next_block, rotated_problem } = problem
    |> Helper.rotate_cw
    |> Helper.right_with_next(block)

    { 
      next_block,
      rotated_problem
      |> Helper.rotate_ccw
    }
  end

  @doc """
  Finds and moves a block right by 1 in a problem

  ## Examples

      iex> UnblockMeSolver.Move.Helper.right_in_row([
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
        Helper.right(row, block)
      else
        row
      end
    end)
  end

  @doc """
  Moves a block right by 1

  ## Examples

      iex> UnblockMeSolver.Move.Helper.right(['A', 'A', nil], 'A')
      [nil, 'A', 'A']

      iex> UnblockMeSolver.Move.Helper.right([nil, 'A', 'A', nil], 'A')
      [nil, nil, 'A', 'A']

  """
  def right(row, block) do
    row
    |> Helper.stretch_right(block)
    |> Helper.shrink_right(block)
  end

  @doc """
  Copies the last block to the adjacent-right cell

  ## Examples

      iex> UnblockMeSolver.Move.Helper.stretch_right(['A', 'A', nil], 'A')
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

      iex> UnblockMeSolver.Move.Helper.shrink_right(['A', 'A', 'A'], 'A')
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
