defmodule AOC23.D15 do
  def run(input) do
    parse(input)
    |> Enum.sum
  end

  def parse(input) do
    input
    |> Enum.map(
    fn(line) ->
      line
      |> String.trim
      |> String.split(",", trim: true)
      #|> IO.inspect
      |> Enum.map(&(hash(&1, 0)))
      #|> IO.inspect
      |> Enum.sum
    end)
  end

  def hash(<<>>, cv), do: cv
  def hash(<<x, xs :: binary>>, cv) do
    hash(xs, rem((cv + x) * 17, 256))
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D15.run(input)

IO.puts(result)
