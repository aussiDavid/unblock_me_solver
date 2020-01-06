defmodule UnblockMeSolver do
  @moduledoc """
  UnblockMeSolver is a solver for the UnblockMe puzzle game.

  This module generates and solves UnblockMe problems in various configurations.

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

  @max_iterations 50
  @starting_block 'A'

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
  * :trivial - (default) A problem with no other blocks. Ideal for testing.
  * :simple - A problem with 1 other block. Ideal for a demo.

  Any other inputs will raise an error.
  """
  def generate(difficulty \\ :trivial) do
    case difficulty do
      :trivial -> UnblockMeSolver.Generator.trivial()
      :simple -> UnblockMeSolver.Generator.simple()
      _ -> raise "Difficulty level not recognised"
    end
  end

  @doc """
  Solves an UnblockMe problem generated from `UnblockMeSolver.generate/1` as a list of moves to solve the problem.

  ## Examples

      iex> UnblockMeSolver.generate(:trivial) |> UnblockMeSolver.solve()
      [
        {'A', :right, 1},
        {'A', :right, 1},
        {'A', :right, 1},
      ]

  """
  def solve(problem) do
    case solve(problem, @starting_block, :right, [], []) do
      nil -> raise "Could not solve the problem"
      solution -> solution
    end
  end

  defp solve(problem, block, direction, moves, chain) do
    cond do
      UnblockMeSolver.Move.solved?(problem, @starting_block) -> moves
      too_long?(chain) -> raise "Exceeded move limit: #{@max_iterations}"
      hit_a_wall?(problem, block, direction) -> nil
      backtracked?(moves, block, direction) -> nil
      cycled?(chain, block, direction) -> nil
      
      true ->
        case UnblockMeSolver.Move.with_next(problem, direction, block) do
          { nil, new_problem } ->
            solve(
              new_problem,
              @starting_block,
              :right,
              Enum.concat(moves, [{block, direction, 1}]),
              []
            )

          { next_block, _ } ->
            new_chain = Enum.concat(chain, [{block, direction}])
            case UnblockMeSolver.Move.direction(problem, next_block) do
              :horizontal ->
                choose(
                  solve(problem, next_block, :left, moves, new_chain),
                  solve(problem, next_block, :right, moves, new_chain)
                )

              :vertical ->
                choose(
                  solve(problem, next_block, :up, moves, new_chain),
                  solve(problem, next_block, :down, moves, new_chain)
                )

              _ -> raise "Could not make a move for #{next_block}"
          end
        end
    end
  end

  defp too_long?(chain) do
    Enum.count(chain) > @max_iterations
  end

  defp backtracked?(moves, block, direction) do
    if Enum.count(moves) == 0 do
      false
    else
      {last_block, last_direction, _} = moves |> Enum.reverse |> Enum.at(0)
      if last_block == block do
        last_direction == case direction do
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

  defp hit_a_wall?(problem, block, direction) do
    { next_block, new_problem } = UnblockMeSolver.Move.with_next(problem, direction, block)
    new_problem == problem && next_block == nil
  end

  defp cycled?(chain, block, direction) do
    chain
    |> Enum.any?(fn {chain_block, chain_direction} ->
      chain_block == block && chain_direction == direction 
    end)
  end

  defp choose(first, second) do
    case {first, second} do
      {nil, nil} -> nil
      {nil, _} -> second
      {_, nil} -> first
      _ -> [first, second] |> Enum.min_by(&Enum.count(&1))
    end
  end
end
