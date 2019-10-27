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
      [
        {'A', :right, 1},
        {'A', :right, 1},
        {'A', :right, 1},
      ]
  """

  @doc """
  Generates problems solvable by the `UnblockMeSolver.solve/1` function. 

  ## Examples

      iex> UnblockMeSolver.generate(:trivial)
      [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        ['A', 'A', nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ]

  The first argument specifies the difficulty. Accepted inputs are:
  * :trivial - A problem with no other blocks. Ideal for testing

  Another other input will raise an error
  """
  def generate(difficulty \\ :trivial) do
    case difficulty do
      :trivial -> UnblockMeSolver.Generator.trivial()
      _ -> raise "Difficulty level not recognised"
    end
  end

  @doc """
  Solves an UnblockMe problem generated from `UnblockMeSolver.generate/1` and returns a list of moves to solve the problem

  ## Examples

      iex> UnblockMeSolver.generate(:trivial) |> UnblockMeSolver.solve()
      [
        {'A', :right, 1},
        {'A', :right, 1},
        {'A', :right, 1},
      ]

  """
  def solve(problem, history \\ []) do
    if UnblockMeSolver.Move.solved?(problem, 'A') do
      history
    else
      new_history = Enum.concat(history, [{'A', :right, 1}])
      new_problem = UnblockMeSolver.Move.right_in_row(problem, 'A')
      
      UnblockMeSolver.solve(new_problem, new_history)
    end
  end
end
