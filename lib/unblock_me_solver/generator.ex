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

  @doc """
  Generates a 5 by 5 problem with 2 blocks.

  Idealy used as a test case or a demo, the solution block is obstucted by another block

  ## Examples

      iex> UnblockMeSolver.Generator.simple()
      [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, 'B', nil],
        ['A', 'A', nil, 'B', nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ]

  """
  def simple do
    [
      [nil, nil, nil, nil, nil],
      [nil, nil, nil, 'B', nil],
      ['A', 'A', nil, 'B', nil],
      [nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil]
    ]
  end

  @doc """
  Generates a 5 by 5 problem with randomly placed blocks.

  There is no garuentee that the problem will be solvable

  """
  def random do
    trivial()
    |> add_blocks(['B'])
  end

  def add_blocks(problem, blocks) do
    if Enum.empty?(blocks) do
      problem
    else
      [ block | remaining_blocks ] = blocks

      problem
      |> UnblockMeSolver.Move.Helper.rotate_cw
      |> add_block(block)
      |> add_blocks(remaining_blocks)
    end
  end

  def add_block(problem, block) do
    index = Enum.random(0..Enum.count(problem))
    new_row = problem
    |> Enum.at(index)
    |> insert_block(block)

    problem
    |> List.replace_at(index, new_row)
  end

  @doc """
  Inserts a block into a row of at least 2 cells long in a row

  ## Examples

      UnblockMeSolver.Generator.insert_block([nil, nil, :A, nil, nil], :B) could equal
      [:B, :B, :A, nil, nil]

      UnblockMeSolver.Generator.insert_block([nil, nil, nil, :A, nil, nil], :B) could equal
      [:B, :B, nil, :A, nil, nil]

  """
  def insert_block(row, block) do
    chunks = row
    |> Enum.chunk_by(fn x -> x != nil end)

    index = Enum.find_index(chunks, fn chunk -> Enum.any?(chunk, fn x -> x == nil end) end)
    chunk = Enum.find(chunks, fn chunk -> Enum.any?(chunk, fn x -> x == nil end) end)

    max_length = Enum.count(chunk)
    nums = Enum.random(2..max_length)

    chunks
    |> List.replace_at(index, mylist(nums, block, max_length))
    |> List.flatten
  end

  @doc """
  Generates a list of x values. The remainder of the space is filled with nil (otherwise specified)

  If y is less than x, an empty list is returned

  ## Examples

      iex> UnblockMeSolver.Generator.mylist(2, :A, 1)
      []

      iex> UnblockMeSolver.Generator.mylist(2, :A, 2)
      [:A, :A]

      iex> UnblockMeSolver.Generator.mylist(2, :A, 3)
      [:A, :A, nil]

      iex> UnblockMeSolver.Generator.mylist(2, :A, 4)
      [:A, :A, nil, nil]

  """
  def mylist(x, value, y, default \\ nil) do
    cond do
      x == y -> Enum.map(1..x, fn _ -> value end)
      y < x -> []
      true ->
        Enum.map(1..x, fn _ -> value end) ++
          Enum.map((x+1)..y, fn _ -> default end)
    end
  end
end
