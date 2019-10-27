defmodule UnblockMeSolver.Move.MoveTest do
  use ExUnit.Case
  doctest UnblockMeSolver.Move

  describe "solved?/2" do
    test "when a the solution block is on the second row and solved" do
      assert UnblockMeSolver.Move.solved?([
        [nil, nil],
        ['A', 'A']
      ], 'A') == true
    end

    test "when a the solution block is on the first of 2 rows and solved" do
      assert UnblockMeSolver.Move.solved?([
        ['A', 'A'],
        [nil, nil]
      ], 'A') == true
    end

    test "when a the solution block is on the first of 2 rows and not solved" do
      assert UnblockMeSolver.Move.solved?([
        ['A', 'A', nil],
        [nil, nil, nil]
      ], 'A') == false
    end
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
