defmodule UnblockMeSolver do
  @moduledoc """
  Documentation for UnblockMeSolver.
  """

  @doc """
  Generates a 5 by 5 problem of blocks.

  ## Examples

      [
        ['B', 'B', nil, nil, nil],
        ['C', 'C', nil, nil, nil],
        ['A', 'A', nil, nil, nil],
        ['D', 'D', nil, nil, nil],
        ['E', 'E', nil, nil, nil]
      ]

  """
  def generate_problem do
    [
      ['B', 'B', nil, 'G', 'G'],
      ['C', 'C', nil, nil, 'F'],
      ['A', 'A', nil, nil, 'F'],
      ['D', 'D', nil, nil, nil],
      ['E', 'E', nil, nil, nil]
    ]
  end

  @doc """
  Determines if the problem is solvable
  A problem is solvable when there are empty spaces to the right of the solution block ['A', 'A']

  ## Examples

      iex> UnblockMeSolver.solvable?([
      ...>  ['B', 'B', nil, nil, nil],
      ...>  ['C', 'C', nil, nil, nil],
      ...>  ['A', 'A', nil, nil, nil],
      ...>  ['D', 'D', nil, nil, nil],
      ...>  ['E', 'E', nil, nil, nil],
      ...>])
      true
  """
  def solvable? problem do
    problem
      |> UnblockMeSolver.extract_solution_row
      |> Enum.drop_while(fn x -> x != 'A' end)
      |> Enum.filter(fn x -> x != 'A' end)
      |> Enum.all?(fn x -> x == nil end)
  end

  @doc """
  Computes the moves required to solve the problem

  ## Examples

      iex> UnblockMeSolver.solve([
      ...>  ['B', 'B', nil, nil, nil],
      ...>  ['C', 'C', nil, nil, nil],
      ...>  ['A', 'A', nil, nil, nil],
      ...>  ['D', 'D', nil, nil, nil],
      ...>  ['E', 'E', nil, nil, nil],
      ...>])
      [{'A', :right, 3}]

  """
  def solve problem do
    if UnblockMeSolver.solvable?(problem) do
      moves = problem
        |> UnblockMeSolver.extract_solution_row
        |> Enum.drop_while(fn x -> x != 'A' end)
        |> Enum.filter(fn x -> x != 'A' end)
        |> Enum.count(fn x -> x == nil end)

      [{'A', :right, moves}]
    else
      # UnblockMeSolver.solve problem
      []
    end
  end

  @doc """
  Determines the problem chain of blocks stopping the 'A' block from moving to the exit

  ## Examples

      iex> UnblockMeSolver.problem_chain([
      ...>  ['B', 'B', nil, nil, nil],
      ...>  ['C', 'C', nil, nil, 'F'],
      ...>  ['A', 'A', nil, nil, 'F'],
      ...>  ['D', 'D', nil, nil, nil],
      ...>  ['E', 'E', nil, nil, nil],
      ...>])
      ['F']

  """
  def problem_chain problem, chain \\ [], iterations \\ 10 do
    cond do
      UnblockMeSolver.solvable?(problem) ->
        chain
      iterations < 1 ->
        raise "the solution took too long"
      true ->
        problem
          |> UnblockMeSolver.extract_solution_row
          |> Enum.filter(fn x -> x != 'A' end)
          |> Enum.filter(fn x -> x != nil end)
          |> Enum.uniq
    end
  end

  @doc """
  Extracts the middle row from a problem

  ## Examples

      iex> UnblockMeSolver.extract_solution_row([
      ...>  ['B', 'B', nil, nil, nil],
      ...>  ['C', 'C', nil, nil, nil],
      ...>  ['A', 'A', nil, nil, nil],
      ...>  ['D', 'D', nil, nil, nil],
      ...>  ['E', 'E', nil, nil, nil],
      ...>])
      ['A', 'A', nil, nil, nil]

  """
  def extract_solution_row problem do
    index = length(problem) / 2 |> floor
    case Enum.fetch problem, index do
      {:ok, row} -> row
      _ -> []
    end
  end

  def rotate_ccw problem do
    problem
      |> Enum.map(&Enum.reverse/1)
      |> Transpose.transpose
  end

  def rotate_cw problem do
    problem
      |> Transpose.transpose
      |> Enum.map(&Enum.reverse/1)
  end
end
