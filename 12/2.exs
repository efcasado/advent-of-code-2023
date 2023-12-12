defmodule AOC23.D12 do
  def run(input, nfolds) do
    input
    |> Enum.map(
    fn(line) ->
      [rec0, sol0] =
      line
      |> String.trim
      |> String.split(" ")

      rec = String.split(rec0, "", trim: true) |> List.duplicate(nfolds) |> Enum.join("?")
      sol = String.split(sol0, ",") |> Enum.map(&String.to_integer/1) |> List.duplicate(nfolds) |> List.flatten

      {rec, sol}
    end)
    |> Enum.reduce(0, fn({rec, sol}, acc) ->
      acc + expand(rec, sol)
    end)
  end

  def pmap(collection, f) do
    collection
    |> Task.async_stream(&f.(&1), timeout: :infinity)
    |> Enum.map(fn({:ok, res}) -> res end)
  end

  def expand(xs, _sol, prev \\ nil, n \\ 0)

  def expand(<<>>,  [], _prev, _n), do: 1
  def expand(<<>>, [n],   "#",  n), do: 1

  def expand(       <<>>,      _,     _,  _),
    do: 0
  def expand(<<"#",  _ :: binary>>,     [], _prev, _n),
    do: 0
  def expand(<<"#",  _ :: binary>>, [n| _], _prev,  n),
    do: 0
  def expand(        _xs, [s| _], _prev,  n) when n > s,
    do: 0
  def expand(<<".",  _ :: binary>>, [s| _],   "#",  n) when n < s,
    do: 0

  def expand(<<"?", xs :: binary>>, [s| _s] = sol, prev, n) when n >= s,
    do: mexpand("." <> xs, sol, prev, n)
  def expand(<<"?", xs :: binary>>, sol, prev, n),
    do: mexpand("." <> xs, sol, prev, n) + mexpand("#" <> xs, sol, prev, n)
  def expand(<<".", xs :: binary>>, [_| sol], "#", _n),
    do: mexpand(xs, sol, ".", 0)
  def expand(<<".", xs :: binary>>, sol, _, _n),
    do: mexpand(xs, sol, ".", 0)
  def expand(<<"#", xs :: binary>>, sol, _prev, n),
    do: mexpand(xs, sol, "#", n + 1)

  def mexpand(xs, sol, prev, n) do
    memoized({xs, sol, n}, fn() -> expand(xs, sol, prev, n) end)
  end

  def memoized(key, fun) do
    with nil <- Process.get(key) do
      fun.() |> tap(&(Process.put(key, &1)))
    end
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D12.run(input, 5)

IO.puts(result)
