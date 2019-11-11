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

    test "when there is a block in the way" do
      assert UnblockMeSolver.solve([
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
        [nil, nil, nil],
      ]) == [
        {'B', :down, 1},
        {'A', :right, 1}
      ]
    end

    test "when there is a block in the way with space to move up" do
      assert UnblockMeSolver.solve([
        [nil, nil, nil],
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
        [nil, nil, nil],
      ]) == [
        {'B', :down, 1},
        {'A', :right, 1}
      ]
    end

    test "when there is a block in the way with an extra column" do
      assert UnblockMeSolver.solve([
        ['A', 'A', 'B', nil],
        [nil, nil, 'B', nil],
        [nil, nil, nil, nil],
      ]) == [
        {'B', :down, 1},
        {'A', :right, 1},
        {'A', :right, 1}
      ]
    end

    test "when there are 2 adjacent blocks in the way" do
      assert UnblockMeSolver.solve([
        ['A', 'A', 'B', 'C'],
        [nil, nil, 'B', 'C'],
        [nil, nil, nil, nil],
      ]) == [
        {'B', :down, 1},
        {'A', :right, 1},
        {'C', :down, 1},
        {'A', :right, 1}
      ]
    end

    test "when there are 2 intersecting blocks in the way" do
      assert UnblockMeSolver.solve([
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
        [nil, 'C', 'C'],
      ]) == [
        {'C', :left, 1},
        {'B', :down, 1},
        {'A', :right, 1}
      ]
    end

    test "when there are 4 intersecting blocks in the way" do
      assert UnblockMeSolver.solve([
        ['A', 'A', 'B'],
        [nil, nil, 'B'],
        ['D', nil, 'B'],
        ['D', 'C', 'C'],
      ]) == [
        {'D', :up, 1},
        {'C', :left, 1},
        {'B', :down, 1},
        {'A', :right, 1}
      ]
    end

    # test "when there are 5 intersecting blocks in the way" do
    #   assert UnblockMeSolver.solve([
    #     [nil, nil, 'A', 'A', 'B'],
    #     [nil, 'E', 'E', nil, 'B'],
    #     [nil, nil, 'D', nil, 'B'],
    #     [nil, nil, 'D', 'C', 'C'],
    #   ]) == [
    #     {'E', :left, 1},
    #     {'D', :up, 1},
    #     {'C', :left, 1},
    #     {'B', :down, 1},
    #     {'A', :right, 1}
    #   ]
    # end
  end
end
