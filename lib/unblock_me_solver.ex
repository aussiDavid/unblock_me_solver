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
  * :simple - A problem with 1 other block. Ideal for a demo

  Another other input will raise an error
  """
  def generate(difficulty \\ :trivial) do
    case difficulty do
      :trivial -> UnblockMeSolver.Generator.trivial()
      :simple -> UnblockMeSolver.Generator.simple()
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
  def solve(problem) do
    choose(
      nil,
      solve(problem, 'A', :right, [], [], 1)
    )
  end

  defp solve(problem, block, direction, history, chain, iteration) do
    cond do
      iteration > 50 -> raise "Took too many moves"
      UnblockMeSolver.Move.solved?(problem, 'A') -> history
      has_backtracked?(history, block, direction) -> nil
      move_will_hit_a_wall?(problem, block, direction) -> nil
      cycle_detected?(chain, block) -> nil

      true ->
        case UnblockMeSolver.Move.with_next(problem, direction, block) do
        { nil, new_problem } ->
          new_history = Enum.concat(history, [{block, direction, 1}])
          choose(
            nil,
            solve(new_problem, 'A', :right, new_history, [], iteration + 1)
          )

        { next_block, _ } ->
          new_chain = Enum.concat(chain, [block])
          case UnblockMeSolver.Move.direction(problem, next_block) do
            :horizontal ->
              choose(
                solve(problem, next_block, :left, history, new_chain, iteration + 1),
                solve(problem, next_block, :right, history, new_chain, iteration + 1)
              )

            :vertical ->
              choose(
                solve(problem, next_block, :up, history, new_chain, iteration + 1),
                solve(problem, next_block, :down, history, new_chain, iteration + 1)
              )

            _ -> raise "Could not make a move for #{next_block}"
          end
        end
    end
  end

  defp choose(first, second) do
    case {first, second} do
      {nil, nil} -> nil # raise "Can not solve this"
      {nil, _} -> second
      {_, nil} -> first
      _ -> Enum.min_by([first, second], fn list -> Enum.count(list) end)
    end
  end

  defp has_backtracked?(history, block, direction) do
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

  defp move_will_hit_a_wall?(problem, block, direction) do
    { next_block, new_problem } = UnblockMeSolver.Move.with_next(problem, direction, block)
    new_problem == problem && next_block == nil
  end

  defp cycle_detected?(chain, block) do
    if Enum.empty?(chain) do
      false
    else
      Enum.member?(chain, block)
    end
  end
end
