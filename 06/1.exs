defmodule AOC23.D06 do
  def run(input) do
    [ts0, ds0] = Enum.take(input, 2)
    ts1 = parse_line(ts0)
    ds1 = parse_line(ds0)


    Enum.zip(ts1, ds1)
    |> Enum.map(fn(r) -> Enum.count(wins(0, r, [])) end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def parse_line(line0) do
    Regex.scan(~r/(\d+)/, line0)
    |> Enum.map(fn([n, _]) -> String.to_integer(n) end)
  end

  def wins(_n, {0, _d}, acc), do: acc
  def wins(n, {t, d}, acc) when n * t > d, do: wins(n + 1, {t - 1, d}, [{n, t}| acc])
  def wins(n, {t, d}, acc), do: wins(n + 1, {t - 1, d}, acc)
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D06.run(input)

IO.puts(result)
