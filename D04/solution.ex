defmodule D04 do
   def part1(input) do
      input
      |> Enum.map(&String.replace(&1, ~r/Card\s+\d+: /, ""))
      |> Enum.map(&String.split(&1, " | "))
      |> Enum.map(&reformat_list/1)
      |> Enum.map(&get_same_count/1)
      |> Enum.reject(fn x -> x == 0 end)
      |> Enum.map(fn x -> Integer.pow(2, x-1) end)
      |> Enum.sum
   end

   def reformat_list([x,y]) do
      {split_list_int(x),
      split_list_int(y)}
   end

   def split_list_int(list) do
      list
      |> String.split(" ") 
      |> Enum.map(&String.to_integer/1)
   end

   def get_same_count({l1,l2}) do
      get_same_count(l1, l2, l1 |> Enum.map(fn _ -> 1 end) |> Enum.sum)
   end

   def get_same_count(l1, l2, l1_count) do
      l1 -- l2
      |> Enum.map(fn _ -> 1 end)
      |> Enum.sum
      |> then(fn x -> l1_count - x end)
   end

   def part2(input) do
      input
      |> Enum.map(&String.replace(&1, ~r/Card\s+\d+: /, ""))
      |> Enum.map(&String.split(&1, " | "))
      |> Enum.map(&reformat_list/1)
      |> Enum.map(&get_same_count/1)
      |> Stream.with_index(1)
      |> Enum.reduce(%{}, fn({v,k}, acc) -> Map.put(acc, k, v) end)
      |> diver
      |> IO.inspect
   end

   def diver(cards) do
      cards
      |> Enum.map(fn x -> dive_winner(x, cards) end)
      |> Enum.sum
   end

   def dive_winner({index, card}, cards) do
      if card == 0 do
         1
      else
         index+1..index+card
         |> Enum.map(fn x -> dive_winner({x,cards[x]}, cards) end)
         |> Enum.sum
         |> then(fn x -> x+1 end)
      end
   end
end

defmodule Main do
   def execute(day) do
      input = Input.file(day)
      |> String.replace(~r/ +/, " ")
      |> String.split("\n")

      #D04.part1(input) |> IO.puts
      D04.part2(input) #|> IO.puts
   end
end