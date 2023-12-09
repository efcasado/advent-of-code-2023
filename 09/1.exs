defmodule AOC23.D09 do
  def run(input) do
    input
    |> Enum.reduce(0,
    fn(line, acc) ->
      line
      |> String.trim
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> extrapolated
      |> Enum.sum
      |> Kernel.+(acc)
    end)
  end

  def extrapolated(xs, acc \\ []) do
    [t| _] = Enum.reverse(xs)
    case Enum.all?(xs, fn(0) -> true; (_) -> false end) do
      true  -> [t| acc]
      false -> diffs(xs) |> extrapolated([t| acc])
    end
  end

  def diffs(xs, acc \\ [])
  def diffs([_], acc), do: Enum.reverse(acc)
  def diffs([x1, x2| xs], acc), do: diffs([x2| xs], [x2 - x1| acc])
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D09.run(input)

IO.puts(result)
