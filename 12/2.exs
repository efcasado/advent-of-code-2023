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
    |> Enum.reduce(0, fn({rec, sol}, acc) ->
    # |> pmap(fn({rec, sol}) ->
      IO.puts "XXX"
      acc + expand(rec, sol)
    end)
  end

  # def pmap(collection, f) do
  #   collection
  #   |> Task.async_stream(&f.(&1), max_concurrency: 4, timeout: :infinity)
  #   |> Enum.map(fn({:ok, res}) -> res end)
  # end

  def expand(xs, _sol, prev \\ nil, n \\ 0, acc \\ 1)

  def expand([],  [], _prev, _n, acc),
    do: acc
  def expand([], [s],   "#",  n, acc) when n == s,
    do: acc

  def expand(       [],      _,     _,   _,   _),             do: 0
  def expand(["#"|  _],     [], _prev, _n, _acc),             do: 0
  def expand(      _xs, [s| _], _prev,  n, _acc) when n > s,  do: 0
  def expand(["#"|  _], [s| _], _prev,  n, _acc) when n == s, do: 0
  def expand(["."|  _], [s| _],   "#",  n, _acc) when n < s,  do: 0

  def expand(["?"| xs], [s| _s] = sol, prev, n, acc) when n >= s,
    do: expand(["."| xs], sol, prev, n, acc)
  def expand(["?"| xs], sol, prev, n, acc),
    do: expand(["."| xs], sol, prev, n, acc) + expand(["#"| xs], sol, prev, n, acc)
  def expand(["."| xs], [_| sol], "#", _n, acc),
    do: expand(xs, sol, ".", 0, acc)
  def expand(["."| xs], sol, _, _n, acc),
    do: expand(xs, sol, ".", 0, acc)
  def expand(["#"| xs], sol, _prev, n, acc),
    do: expand(xs, sol, "#", n + 1, acc)
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D12.run(input, 1)

IO.puts(result)
