defmodule D01 do
	def part1(input) do
		input
		|> Enum.map(fn x -> String.graphemes(x) end)
  		|> Enum.map(&get_numbers_from_array/1)
		|> Enum.sum()
	end

 	def get_numbers_from_array(input) do
		input
  		|> Enum.map(&get_number/1)
		|> Enum.filter(fn x -> x != -1 end)
  		|> then(fn y ->
			List.first(y)*10+List.last(y)
 		end)
   	end

 	def get_number(character) do
		Integer.parse(character, 10)
  		|> case do
			:error -> -1
   			{x, _} -> x
 		end
  	end

	def part2(input) do
		input
  		|> Enum.map(
			fn x -> combine_split(x)
			|> get_numbers_from_array()
   		end)
		|> Enum.sum()
	end

 	def combine_split(input) do
		[split_alpha(input), split_alpha_inverted(input)]
  	end

	def split_alpha_inverted(input) do
		Regex.scan(~r/(enin|thgie|neves|xis|evif|ruof|eerht|owt|eno|[0-9])/, input |> String.reverse)
		|> then(fn [[x,_]|_] -> replace_alpha(x |> String.reverse) end)
 	end

 	def split_alpha(input) do
		Regex.scan(~r/(one|two|three|four|five|six|seven|eight|nine|[0-9])/, input)
  		|> then(fn [[x,_]|_] -> replace_alpha(x) end)
   	end
 
 	def replace_alpha(input) do
		input
  		|> String.replace("one", "1")
		|> String.replace("two", "2")
		|> String.replace("three", "3")
		|> String.replace("four", "4")
		|> String.replace("five", "5")
		|> String.replace("six", "6")
		|> String.replace("seven", "7")
		|> String.replace("eight", "8")
		|> String.replace("nine", "9")
  	end
end

defmodule Main do
	def execute(day) do
		input = Input.file(day) 
  		|> String.split("\n") 

		D01.part1(input) |> IO.puts
		D01.part2(input) |> IO.puts
	end
end