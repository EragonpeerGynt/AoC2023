defmodule D03 do
   def part1(input) do
      input
      |> then(
         fn x -> 
            {split_map(x), 
            get_int_indexes(x)
            |> Enum.map(fn y -> y |> get_all_nearby() end)
            |> List.flatten}
         end)
      |> sum_values
   end

   def sum_values({map, values}) do
      values
      |> Enum.map(fn x -> include_value(x, map) end)
      |> Enum.sum
   end

   def include_value({value, checks}, map) do
      if checks |> Enum.any?(fn x -> get_map_value(map, x) != "." end) do
         value
      else
         0
      end
   end

   def get_map_value(map, {c_x,c_y}) do
      case Map.fetch(map, {c_y,c_x}) do
         :error -> "."
         {:ok, x} -> x
      end
   end

   def split_map(input) do
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Maping.create_map()
   end

   def get_int_indexes(input) do
      input
      |> String.split("\n")
      |> Enum.map(fn x -> get_full_int_config(x) end)
      |> then(fn x -> [0..((x |> Enum.map(fn _ -> 1 end) |> Enum.sum)-1), x] |> Enum.zip() end)
   end

   def get_full_int_config(line) do
      [Regex.scan(~r/\d+/u, line, return: :index),
      Regex.scan(~r/\d+/u, line)]
      |> Enum.zip()
      |> Enum.map(fn {[c], [v]} -> {c, String.to_integer(v)} end)
   end

   def get_all_nearby({line, ranges}) do
      ranges
      |> Enum.map(fn {r, v} -> get_full_matrix({line,r,v}) end)
   end

   def get_full_matrix({index_h, range, value}) do
      get_full_height(index_h)
      |> get_full_matrix(get_full_range(range), value)
      |> then(fn x -> reject_not_important(x, index_h, range) end)
   end

   def reject_not_important({value, range}, height, {r_s, r_c}) do
      range
      |> Enum.reject(fn {x,y} -> x < 0 || y < 0 end)
      |> Enum.reject(fn {x,y} -> x == height && (y >= r_s && y < r_s+r_c) end)
      |> then(fn x -> {value, x} end)
   end

   def get_full_matrix(height, range, value) do
      height
      |> Enum.map(fn h -> range |> Enum.map(fn r -> {h,r} end) end)
      |> List.flatten
      |> then(fn x -> {value, x} end)
   end

   def get_full_height(height) do
      [height-1, height, height+1]
   end

   def get_full_range({x, y}) do
      get_range(x-1, y+1)
   end

   def get_range(current, 0) do
      [current]
   end

   def get_range(current, remaining) do
      [current | get_range(current+1, remaining-1)]
   end

   def part2(input) do
      input
   end
end

defmodule Main do
   def execute(day) do
      input = Input.file(day)
      
      D03.part1(input) |> IO.puts
      #D03.part2(input) |> IO.puts
   end
end