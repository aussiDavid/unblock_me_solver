defmodule UnblockMeSolver.Move.MoveTest do
  use ExUnit.Case
  doctest UnblockMeSolver.Move

  describe "problem_chain/1" do
    test "when there are no blocks in the way of solving the problem" do
      assert UnblockMeSolver.Move.problem_chain([
               ['B', 'B', nil, nil, nil],
               ['C', 'C', nil, nil, nil],
               ['A', 'A', nil, nil, nil],
               ['D', 'D', nil, nil, nil],
               ['E', 'E', nil, nil, nil]
             ]) == []
    end

    test "when there is 1 block in the way and a block that can be ignored" do
      assert UnblockMeSolver.Move.problem_chain([
               [nil, nil, nil, 'G', 'G'],
               [nil, nil, nil, nil, 'F'],
               ['A', 'A', nil, nil, 'F'],
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil]
             ]) == ['F']
    end

    # test "when there are 2 blocks in the way and a block that can be ignored" do
    #   assert UnblockMeSolver.Move.problem_chain([
    #       [nil, nil, nil, 'G', 'G'],
    #       [nil, nil, nil, nil, 'F'],
    #       ['A', 'A', nil, nil, 'F'],
    #       [nil, nil, nil, 'H', 'H'],
    #       [nil, nil, nil, nil, nil],
    #     ]) == ['F', 'G']
    # end
  end

  describe "solvable?/1" do
    test "when a block is in the way on the last column" do
      assert UnblockMeSolver.Move.solvable?([
               ['B', 'B', nil, nil, nil],
               ['C', 'C', nil, nil, 'F'],
               ['A', 'A', nil, nil, 'F'],
               ['D', 'D', nil, nil, nil],
               ['E', 'E', nil, nil, nil]
             ]) == false
    end

    test "when the problem is solvable with a block in the last column" do
      assert UnblockMeSolver.Move.solvable?([
               [nil, nil, nil, nil, 'F'],
               [nil, nil, nil, nil, 'F'],
               ['A', 'A', nil, nil, nil],
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil]
             ]) == true
    end

    test "when the problem is solvable with a block in the last column at the bottom" do
      assert UnblockMeSolver.Move.solvable?([
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil],
               ['A', 'A', nil, nil, nil],
               [nil, nil, nil, nil, 'F'],
               [nil, nil, nil, nil, 'F']
             ]) == true
    end

    test "when the problem is solvable with the solution block starting at the 2nd column" do
      assert UnblockMeSolver.Move.solvable?([
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil],
               [nil, 'A', 'A', nil, nil],
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil]
             ]) == true
    end

    test "when the problem is solvable with the solution block starting at the 3rd column" do
      assert UnblockMeSolver.Move.solvable?([
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil],
               [nil, nil, 'A', 'A', nil],
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil]
             ]) == true
    end

    test "when the problem is solvable with the solution as at the last column" do
      assert UnblockMeSolver.Move.solvable?([
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, 'A', 'A'],
               [nil, nil, nil, nil, nil],
               [nil, nil, nil, nil, nil]
             ]) == true
    end

    test "when the problem is solvable with a block behind the solution block" do
      assert UnblockMeSolver.Move.solvable?([
          [nil, nil, nil, nil, nil],
          ['B', nil, nil, nil, nil],
          ['B', 'A', 'A', nil, nil],
          [nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil]
        ]) == true
    end
  end
end
