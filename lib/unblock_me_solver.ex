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

      # iex> UnblockMeSolver.generate(:trivial) |> UnblockMeSolver.solve()
      # [
      #   {'A', :right, 1},
      #   {'A', :right, 1},
      #   {'A', :right, 1},
      # ]
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

      # iex> UnblockMeSolver.generate(:trivial) |> UnblockMeSolver.solve('A')
      # [
      #   {'A', :right, 1},
      #   {'A', :right, 1},
      #   {'A', :right, 1},
      # ]

  """
  def solve(problem, block \\ 'A', direction \\ nil, history \\ [], iteration \\ 1) do
    cond do
      UnblockMeSolver.Move.solved?(problem, 'A') -> history
      iteration > 20 -> raise "Took too many moves"
      reverse?(history, block, direction) -> nil

      direction == nil ->
        case UnblockMeSolver.Move.direction(problem, block) do
          :horizontal -> solve_helper(problem, block, :left, :right, history, iteration)
          :vertical -> solve_helper(problem, block, :up, :down, history, iteration)
          _ -> raise "Could not make a move for #{block}"
        end

      true ->
        case UnblockMeSolver.Move.with_next(problem, direction, block) do
          { nil, updated_problem } -> cond do
            updated_problem == problem ->
              nil
            
            true ->
              solve(updated_problem, 'A', nil, Enum.concat(history, [{block, direction, 1}]), iteration + 1)
          end

          { next_block, _ } ->
            solve(problem, next_block, nil, history, iteration + 1)
        end
    end
  end

  def choose(first, second) do
    case {first, second} do
      {nil, nil} -> nil # raise "Can not solve this"
      {nil, _} -> second
      {_, nil} -> first
      _ -> Enum.min_by([first, second], fn list -> Enum.count(list) end)
    end
  end

  def solve_helper(problem, block, first_dir, second_dir, history, iteration) do
    if Enum.count(history) > 0 do
      {b, d, _} = Enum.reverse(history) |> Enum.at(0)
      first = cond do
        b == block && d == second_dir -> nil
        true -> solve(problem, block, first_dir, history, iteration + 1)
      end
      second = cond do
        b == block && d == first_dir -> nil
        true -> solve(problem, block, second_dir, history, iteration + 1)
      end
      choose(first, second)
    else
      choose(
        solve(problem, block, first_dir, history, iteration + 1),
        solve(problem, block, second_dir, history, iteration + 1)
      )
    end
  end

  def reverse?(history, block, direction) do
    if Enum.count(history) == 0 do
      false
    else
      {a, b, _} = Enum.reverse(history) |> Enum.at(0)
      if a == block do
        b == case direction do
          :left -> :right
          :right -> :left
          :up -> :down
          :down -> :up
          _ -> nil
        end
      else
        false
      end
    end
  end
end
