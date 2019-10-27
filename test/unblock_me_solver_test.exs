defmodule UnblockMeSolverTest do
  use ExUnit.Case
  doctest UnblockMeSolver

  describe "solve/1" do
    test "when the problem is already solved" do
      assert UnblockMeSolver.solve([['A', 'A']]) == []
    end

    test "when the problem is almost solved" do
      assert UnblockMeSolver.solve([['A', 'A', nil]]) == [{'A', :right, 1}]
    end

    test "when the problem is will be solved in 2 moves to the right" do
      assert UnblockMeSolver.solve([
        ['A', 'A', nil, nil]
      ]) == [
        {'A', :right, 1},
        {'A', :right, 1}
      ]
    end

    test "when the problem is will be solved in 1 move with 2 empty rows" do
      assert UnblockMeSolver.solve([
        ['A', 'A', nil],
        [nil, nil, nil],
        [nil, nil, nil],
      ]) == [{'A', :right, 1}]
    end

    # test "when there is a block in the way" do
    #   assert UnblockMeSolver.solve([
    #     ['A', 'A', 'B'],
    #     [nil, nil, 'B'],
    #     [nil, nil, nil],
    #   ]) == [
    #     {'B', :down, 1},
    #     {'A', :right, 1}
    #   ]
    # end
  end
end
