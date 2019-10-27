defmodule UnblockMeSolverTest do
  use ExUnit.Case
  doctest UnblockMeSolver

  describe "solve/1" do
    test "when the problem is already solved" do
      assert UnblockMeSolver.solve([['A', 'A']]) == []
    end
  end
end
