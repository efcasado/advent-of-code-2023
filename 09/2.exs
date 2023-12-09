defmodule AOC23.D09 do
  def run(input) do
    input
    |> Enum.reduce(0,
    fn(line, acc) ->
      line
      |> String.trim
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> extrapolate
      |> Enum.reduce(0, &Kernel.-(&1, &2))
      |> Kernel.+(acc)
    end)
  end

  def extrapolate([x| _] = xs, acc \\ []) do
    case Enum.all?(xs, fn(0) -> true; (_) -> false end) do
      true  -> [x| acc]
      false -> diffs(xs) |> extrapolate([x| acc])
    end
  end

  def diffs(xs, acc \\ [])
  def diffs([_], acc), do: Enum.reverse(acc)
  def diffs([x1, x2| xs], acc), do: diffs([x2| xs], [x2 - x1| acc])
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D09.run(input)

IO.puts(result)
