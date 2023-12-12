defmodule AOC23.D12 do
  def run(input) do
    input
    |> Enum.map(
    fn(line) ->
      [rec0, sol0] =
      line
      |> String.trim
      |> String.split(" ")

      rec = String.split(rec0, "", trim: true)
      sol = String.split(sol0, ",") |> Enum.map(&String.to_integer/1)
      {rec, sol}
    end)
    |> Enum.map(fn({rec, sol}) ->
      expand(rec)
      |> Enum.filter(fn(r) -> valid?(r, sol) end)
      |> Enum.count
    end)
    |> Enum.sum
  end

  def valid?(rec, sol), do: sol == groups(rec)

  def groups(xs, n \\ 0, gs \\ [])
  def groups([], 0, gs), do: Enum.reverse(gs)
  def groups([], n, gs), do: Enum.reverse([n| gs])
  def groups(["."| xs], 0, gs), do: groups(xs, 0, gs)
  def groups(["."| xs], n, gs), do: groups(xs, 0, [n| gs])
  def groups(["#"| xs], n, gs), do: groups(xs, n + 1, gs)

  def expand(xs, acc \\ [[]])
  def expand([], acc) do
    Enum.map(acc, &Enum.reverse/1)
  end
  def expand(["?"| xs], acc0) do
    acc1 = Enum.map(acc0, fn(a) -> ["."| a] end)
    acc2 = Enum.map(acc0, fn(a) -> ["#"| a] end)
    expand(xs, acc1 ++ acc2)
  end
  def expand([x| xs], acc0) do
    acc = Enum.map(acc0, fn(a) -> [x| a] end)
    expand(xs, acc)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D12.run(input)

IO.puts(result)
