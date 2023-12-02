defmodule D02 do
  	def parse_game(game) do
		game
  		|> String.split(": ")
		|> then(fn [name, rounds] -> {parse_game_name(name), parse_rounds(rounds)} end)
   	end

 	def parse_game_name(<<"Game ", game_number::binary>>) do
		String.to_integer(game_number)
  	end

   	def parse_rounds(rounds) do
		rounds
  		|> String.split("; ")
		|> Enum.map(&parse_round/1)
 	end

  	def parse_round(round) do
		round
  		|> String.split(", ")
		|> Enum.map(&parse_block/1)	
   	end

 	def parse_block(block) do
		block
  		|> String.split(" ")
		|> then(fn [n,c] -> {c, String.to_integer(n)} end)
  	end

 	def storage() do
		%{"red" => 12,
  		"green" => 13,
		"blue" => 14}
  	end

   	def empty_storage() do
		%{"red" => 0,
		"green" => 0,
		"blue" => 0}
 	end

   	def update_storage(storage, {new_element, value}) do
		%{storage | new_element => storage[new_element] - value}
 	end

  	def update_max_storage(storage, {new_element, value}) do
		case greater(storage[new_element], value) do
  			:old -> storage
	 		_ -> %{storage | new_element => value}
		end
   	end

  	def greater(current, new) do
		if new > current do
  			new
	 	else
			:old
		end
   	end

 	def part1(input, storage) do
		input
		|> Enum.map(&parse_game/1)
		|> Enum.map(&colapse_rounds/1)
  		|> Enum.map(fn x -> part1_adder(x, storage) end)
  		|> Enum.sum()
  	end

   	def part1_adder({game,max_round}, storage) do
		if !part1_not_in_range(max_round, storage) do
  			game
	 	else
   			0
	  	end
 	end

  	def part1_not_in_range(max_round, storage) do
		max_round
  		|> Enum.any?(fn {x,y} -> storage[x] < y end)
   	end

 	def part2(input) do
		input
  		|> Enum.map(&parse_game/1)
		|> Enum.map(&colapse_rounds/1)
  		|> Enum.map(&part2_factorio/1)
		|> Enum.sum()
  	end

   	def part2_factorio({_, rounds}) do
		rounds
		|> Enum.map(fn {_,y} -> y end)
  		|> Enum.product()
 	end

   	def colapse_rounds({game, rounds}) do 
		rounds
		|> List.flatten()
  		|> Enum.group_by(fn {x, _} -> x end, fn {_, y} -> y end)
  		|> Map.to_list()
		|> Enum.map(fn {x,y} -> {x, y |> Enum.max()} end)
  		|> then(fn x -> {game, x} end)
 	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")		
	
		D02.part1(input, D02.storage()) |> IO.puts
		D02.part2(input) |> IO.puts
	end
end