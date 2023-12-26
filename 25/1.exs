defmodule AOC23.D25 do
  def run(input) do
    parse(input)
    |> IO.inspect(limit: :infinity)

    0
  end

  def parse(input) do
    input
    |> Enum.flat_map(fn(line) ->
      [from, to] = line
      |> String.trim
      |> String.split(": ", trim: true)

      to = String.split(to, " ", trim: :true)
      [{from, to}| Enum.map(to, &({&1, [from]}))]
    end)
    |> Enum.reduce(%{}, fn({k, v}, g) -> Map.update(g, k, v, fn(v0) -> v0 ++ v end) end)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D25.run(input)

IO.puts(result)
