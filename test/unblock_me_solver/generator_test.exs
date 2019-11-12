defmodule UnblockMeGeneratorTest do
  use ExUnit.Case
  doctest UnblockMeSolver.Generator

  describe "random/0" do
    test "when there is an A block that covers 2 or more spaces" do
      # assert UnblockMeSolver.Generator.random |> Enum.find(fn row -> row |> Enum.any?(fn x -> x == 'A' end) end) |> Enum.count(fn x -> x == 'A' end) > 2
      # assert UnblockMeSolver.Generator.random |> List.flatten |> Enum.member?('B') == true
    end

    # test "when there is a B block that covers 1 or more spaces" do
    #   assert UnblockMeSolver.Generator.random |> Enum.any?(fn row -> Enum.count(row, fn x -> x == 'B' end) > 0 end) == true
    # end
  end

      # [:B, :B, :A, nil, nil]

      # UnblockMeSolver.Generator.insert_block([nil, nil, nil, :A, nil, nil], :B) could equal
      # [:B, :B, nil, :A, nil, nil]
  describe "insert_block/2" do
    test "when inserting B at the start of a row" do
      :rand.seed(:exsplus, {101, 102, 103})
      assert UnblockMeSolver.Generator.insert_block([nil, nil, :A, nil, nil], :B) == [:B, :B, :A, nil, nil]
    end

    test "when inserting B of length 3 at the start of a row" do
      :rand.seed(:exsplus, {100, 102, 103})
      assert UnblockMeSolver.Generator.insert_block([nil, nil, nil, :A, nil, nil], :B) == [:B, :B, :B, :A, nil, nil]
    end

    test "when inserting B at the start of a row with roow to spare" do
      :rand.seed(:exsplus, {101, 102, 103})
      assert UnblockMeSolver.Generator.insert_block([nil, nil, nil, :A, nil, nil], :B) == [:B, :B, nil, :A, nil, nil]
    end
  end
end
