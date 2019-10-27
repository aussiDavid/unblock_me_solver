defmodule UnblockMeSolver do
  @moduledoc """
  UnblockMeSolver is a solver for the UnblockMe mobile puzzle game. 

  This module to generate and solve UnblockMe problems.
  UnblockMeSolver generates and solves UnblockMe problems in various configurations

  For example, to generate a trivial problem:

      iex> UnblockMeSolver.generate(:trivial)
      [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        ['A', 'A', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ]

  Then solving the problem:

      iex> UnblockMeSolver.generate(:trivial) |> UnblockMeSolver.solve()
      [{'A', :right, 3}]
  """

  @doc """
  Generates a 5 by 5 problem with 1 block.

  Idealy used as a test case, the solution block is unobstructed

  ## Examples

      iex> UnblockMeSolver.generate(:trivial)
      [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        ['A', 'A', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ]

  """
  def generate(difficulty \\ :trivial) do
    case difficulty do
      :trivial -> UnblockMeSolver.Generator.trivial
      _ -> raise "Difficulty level not recognised"
    end
  end

  @doc """
  Solves an UnblockMe problem generated from `UnblockMeSolver.generate/1` and returns a list of moves to solve the problem

  ## Examples

      iex> UnblockMeSolver.generate(:trivial) |> UnblockMeSolver.solve
      [{'A', :right, 3}]

  """
  def solve(problem) do
    if UnblockMeSolver.Move.solvable?(problem) do
      moves =
        problem
        |> UnblockMeSolver.Move.extract_solution_row()
        |> Enum.drop_while(fn x -> x != 'A' end)
        |> Enum.filter(fn x -> x != 'A' end)
        |> Enum.count(fn x -> x == nil end)

      [{'A', :right, moves}]
    else
      # UnblockMeSolver.solve problem
      []
    end
  end
end
