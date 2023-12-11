defmodule AOC23.D11 do
  def run(input) do
    {nrows, ncols, _n, gs} =
      input
      |> Enum.reduce({0, 0, 1, []},
      fn(line, {i, _j, n0, gs0}) ->
        {j, n, gs} =
          line
          |> String.trim
          |> String.split("", trim: true)
          |> Enum.reduce({0, n0, gs0},
          fn
            ("#", {j, n, gs}) -> {j + 1, n + 1, [{n, {i, j}}| gs]}
            (  _, {j, n, gs}) -> {j + 1, n, gs}
          end)
        {i + 1, j, n, gs}
      end)

    xrows = (0..(nrows-1) |> Range.to_list) -- (gs |> Enum.map(fn({_n, { i, _j}}) -> i end))
    xcols = (0..(ncols-1) |> Range.to_list) -- (gs |> Enum.map(fn({_n, {_i,  j}}) -> j end))

    gs
    |> pairs
    |> Enum.reduce(0, fn({from, to}, acc) -> distance(from, to, xrows, xcols) + acc end)
  end

  def pairs(xs, acc \\ [])
  def pairs([], acc), do: acc
  def pairs([x| xs], acc), do: pairs(xs, Enum.zip(List.duplicate(x, Enum.count(xs)), xs) ++ acc)

  def distance({_name1, {x1, y1}}, {_name2, {x2, y2}}, xrows, xcols) do
    (abs(x2 - x1) + abs(y2 - y1)) + xings(xrows, x1, x2) + xings(xcols, y1, y2)
  end

  def xings(xs, p1, p2) when p1 < p2, do: Enum.filter(xs, fn(x) -> x >= p1 and x <= p2 end) |> Enum.count
  def xings(xs, p1, p2),              do: Enum.filter(xs, fn(x) -> x >= p2 and x <= p1 end) |> Enum.count
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D11.run(input)

IO.puts(result)
