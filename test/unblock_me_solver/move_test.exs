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

  describe "direction/2" do
    test "when the block is horizontal" do
      assert UnblockMeSolver.Move.direction([
        [nil, nil, nil, nil],
        [nil, 'A', 'A', nil],
        [nil, nil, nil, nil],
      ], 'A') == :horizontal
    end

    test "when the block is vertical" do
      assert UnblockMeSolver.Move.direction([
        [nil, nil, nil],
        [nil, 'A', nil],
        [nil, 'A', nil],
        [nil, nil, nil],
      ], 'A') == :vertical
    end

    test "when the block is horizontal adjacent to a wall" do
      assert UnblockMeSolver.Move.direction([
        [nil, nil, nil],
        ['A', 'A', nil],
        [nil, nil, nil],
      ], 'A') == :horizontal
    end

    test "when the block is vertical adjacent to a wall" do
      assert UnblockMeSolver.Move.direction([
        [nil, 'A', nil],
        [nil, 'A', nil],
        [nil, nil, nil],
      ], 'A') == :vertical
    end

    test "when the block is not in the problem" do
      assert UnblockMeSolver.Move.direction([
        [nil, 'A', nil],
        [nil, 'A', nil],
        [nil, nil, nil],
      ], 'B') == nil
    end

    test "when the block is in 1 cell" do
      assert UnblockMeSolver.Move.direction([
        [nil, nil, nil],
        [nil, 'A', nil],
        [nil, nil, nil],
      ], 'A') == nil
    end
  end

  describe "with_next/3" do
    test "when moving a block right" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        ['A', 'A', nil],
        [nil, nil, nil],
      ], :right, 'A') == {
        nil,
        [
          [nil, nil, nil],
          [nil, 'A', 'A'],
          [nil, nil, nil],
        ]
      }
    end

    test "when attempting to move a block right blocked by another block" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
      ], :right, 'A') == {
        'B',
        [
          [nil, nil, nil],
          ['A', 'A', 'B'],
          [nil, nil, 'B'],
        ]
      }
    end

    test "when attempting to move a block right blocked by a wall" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        [nil, 'A', 'A'],
        [nil, nil, nil],
      ], :right, 'A') == {
        nil,
        [
          [nil, nil, nil],
          [nil, 'A', 'A'],
          [nil, nil, nil],
        ]
      }
    end

    test "when moving a block left" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        [nil, 'A', 'A'],
        [nil, nil, nil],
      ], :left, 'A') == {
        nil,
        [
          [nil, nil, nil],
          ['A', 'A', nil],
          [nil, nil, nil],
        ]
      }
    end

    test "when attempting to move a block left blocked by a wall" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        ['A', 'A', nil],
        [nil, nil, nil],
      ], :left, 'A') == {
        nil,
        [
          [nil, nil, nil],
          ['A', 'A', nil],
          [nil, nil, nil],
        ]
      }
    end

    test "when moving a block up" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        [nil, 'A', nil],
        [nil, 'A', nil],
      ], :up, 'A') == {
        nil,
        [
          [nil, 'A', nil],
          [nil, 'A', nil],
          [nil, nil, nil],
        ]
      }
    end

    test "when attempting to move a block up blocked by another block" do
      assert UnblockMeSolver.Move.with_next([
        ['B', 'B', nil],
        ['A', nil, nil],
        ['A', nil, nil],
      ], :up, 'A') == {
        'B',
        [
          ['B', 'B', nil],
          ['A', nil, nil],
          ['A', nil, nil],
        ]
      }
    end

    test "when attempting to move a block up blocked by a wall" do
      assert UnblockMeSolver.Move.with_next([
        ['A', nil, nil],
        ['A', nil, nil],
        [nil, nil, nil],
      ], :up, 'A') == {
        nil,
        [
          ['A', nil, nil],
          ['A', nil, nil],
          [nil, nil, nil],
        ]
      }
    end

    test "when moving a block down" do
      assert UnblockMeSolver.Move.with_next([
        [nil, 'A', nil],
        [nil, 'A', nil],
        [nil, nil, nil],
      ], :down, 'A') == {
        nil,
        [
          [nil, nil, nil],
          [nil, 'A', nil],
          [nil, 'A', nil],
        ]
      }
    end

    test "when attempting to move a block down blocked by another block" do
      assert UnblockMeSolver.Move.with_next([
        [nil, 'A', nil],
        [nil, 'A', nil],
        [nil, 'B', 'B'],
      ], :down, 'A') == {
        'B',
        [
          [nil, 'A', nil],
          [nil, 'A', nil],
          [nil, 'B', 'B'],
        ]
      }
    end

    test "when attempting to move a block down blocked by a wall" do
      assert UnblockMeSolver.Move.with_next([
        [nil, nil, nil],
        [nil, 'A', nil],
        [nil, 'A', nil],
      ], :down, 'A') == {
        nil,
        [
          [nil, nil, nil],
          [nil, 'A', nil],
          [nil, 'A', nil],
        ]
      }
    end
  end
end
