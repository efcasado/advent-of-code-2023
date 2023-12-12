defmodule AOC23.D12 do
  def run(input, nfolds) do
    input
    |> Enum.map(
    fn(line) ->
      [rec0, sol0] =
      line
      |> String.trim
      |> String.split(" ")

      rec = String.split(rec0, "", trim: true) |> List.duplicate(nfolds) |> Enum.join("?") |> String.split("", trim: true)
      sol = String.split(sol0, ",") |> Enum.map(&String.to_integer/1) |> List.duplicate(nfolds) |> List.flatten

      {rec, sol}
    end)
    |> Enum.map(fn({rec, sol}) ->
      expand(rec, sol)
      |> Enum.count
    end)
    |> Enum.sum
  end

  def expand(xs, _sol, prev \\ nil, n \\ 0, acc \\ [[]])

  def expand([],  [], _prev, _n, acc),
    do: Enum.map(acc, &Enum.reverse/1)
  def expand([], [s],   "#",  n, acc) when n == s,
    do: Enum.map(acc, &Enum.reverse/1)

  def expand(       [],      _,     _,   _,   _),             do: []
  def expand(["#"|  _],     [], _prev, _n, _acc),             do: []
  def expand(      _xs, [s| _], _prev,  n, _acc) when n > s,  do: []
  def expand(["#"|  _], [s| _], _prev,  n, _acc) when n == s, do: []
  def expand(["."|  _], [s| _],   "#",  n, _acc) when n < s,  do: []

  def expand(["?"| xs], [s| _s] = sol, prev, n, acc0) when n >= s,
    do: expand(["."| xs], sol, prev, n, acc0)
  def expand(["?"| xs], sol, prev, n, acc0),
    do: expand(["."| xs], sol, prev, n, acc0) ++ expand(["#"| xs], sol, prev, n, acc0)
  def expand(["."| xs], [_| sol], "#", _n, acc0),
    do: expand(xs, sol, ".", 0, Enum.map(acc0, fn(a) -> ["."| a] end))
  def expand(["."| xs], sol, _, _n, acc0),
    do: expand(xs, sol, ".", 0, Enum.map(acc0, fn(a) -> ["."| a] end))
  def expand(["#"| xs], sol, _prev, n, acc0),
    do: expand(xs, sol, "#", n + 1, Enum.map(acc0, fn(a) -> ["#"| a] end))
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D12.run(input, 5)

IO.puts(result)
