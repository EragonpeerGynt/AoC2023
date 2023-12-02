defmodule D02 do
	def part1(input) do
		input
  		|> Enum.map(&parse_game/1)
  		|> Enum.map(&check_rounds_check/1)
		|> Enum.sum()
	end

	def check_rounds_check({game, rounds}) do
	 if check_rounds(rounds) do
		 game
	 else
		 0
	 end
	end
	
	def check_rounds(rounds) do
	 rounds
	 |> Enum.all?(fn x -> !check_hand(x) end)
	end
	
	def check_hand(cubes) do
	 cubes
	 |> Enum.reduce_while(storage(), fn x,storage -> update_storage_check(storage, x) end)
	 |> then(&detect_negative/1)
	end
	
	def detect_negative(storage) do
	 storage
	 |> Map.to_list()
	 |> Enum.any?(fn {_,x} -> x < 0 end)
	end
	
	def update_storage_check(storage, insert={new_element, value}) do
	 if storage[new_element] < value do
		 {:halt, update_storage(storage, insert)}
	 else
		 {:cont, update_storage(storage, insert)}
	 end
	end

	def part2(input) do
		input
  		|> Enum.map(&parse_game/1)
		|> Enum.map(&get_factorio_game/1)
		|> Enum.sum()
	end

 	def get_factorio_game(game) do
		game
  		|> get_max_game()
		|> Map.to_list()
  		|> Enum.map(fn {_, x} -> x end)
  		|> Enum.product()
  	end

 	def get_max_game({_,rounds}) do
		rounds
  		|> List.flatten()
		|> Enum.reduce(empty_storage(), fn x,acc -> update_max_storage(acc, x) end)
  	end
 
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
end

defmodule Main do
	def execute(day) do
		input = Input.file(day)
  		|> String.split("\n")		
	
		D02.part1(input) |> IO.puts
		D02.part2(input) |> IO.puts
	end
end