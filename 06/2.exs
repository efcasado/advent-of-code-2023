defmodule AOC23.D06 do
  def run(input) do
    [ts0, ds0] = Enum.take(input, 2)
    ts1 = parse_line(ts0)
    ds1 = parse_line(ds0)

    wins(0, {ts1, ds1}, []) |> Enum.count
  end

  def parse_line(line0) do
    line1 = String.trim(line0)
    line2 = String.replace(line1, " ", "")
    [_, number] = String.split(line2, ":")
    String.to_integer(number)
  end

  def wins(_n, {0, _d}, acc), do: acc
  def wins(n, {t, d}, acc) when n * t > d, do: wins(n + 1, {t - 1, d}, [{n, t}| acc])
  def wins(n, {t, d}, acc), do: wins(n + 1, {t - 1, d}, acc)
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D06.run(input)

IO.puts(result)
