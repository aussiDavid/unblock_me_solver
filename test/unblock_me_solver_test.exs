defmodule UnblockMeSolverTest do
  use ExUnit.Case
  doctest UnblockMeSolver

  test "when there is 1 block in the way of solving the problem" do
    assert UnblockMeSolver.problem_chain([
        ['B', 'B', nil, nil, nil],
        ['C', 'C', nil, nil, 'F'],
        ['A', 'A', nil, nil, 'F'],
        ['D', 'D', nil, nil, nil],
        ['E', 'E', nil, nil, nil],
      ]) == ['F']
  end
end
