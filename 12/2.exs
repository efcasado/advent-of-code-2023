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
    #|> pmap(fn({rec, sol}) ->
      #IO.puts "XXX"
      acc + expand(rec, sol)
      #expand(rec, sol)
    end)
    #|> Enum.sum
  end

  def pmap(collection, f) do
    collection
    |> Task.async_stream(&f.(&1), timeout: :infinity)
    |> Enum.map(fn({:ok, res}) -> res end)
  end

  def expand(xs, _sol, prev \\ nil, n \\ 0, acc \\ 0)

  def expand(<<>>,  [], _prev, _n, acc), do: acc + 1
  def expand(<<>>, [n],   "#",  n, acc), do: acc + 1

  def expand(       <<>>,      _,     _,  _, acc),
    do: acc
  def expand(<<"#",  _ :: binary>>,     [], _prev, _n, acc),
    do: acc
  def expand(<<"#",  _ :: binary>>, [n| _], _prev,  n, acc),
    do: acc
  def expand(        _xs, [s| _], _prev,  n, acc) when n > s,
    do: acc
  def expand(<<".",  _ :: binary>>, [s| _],   "#",  n, acc) when n < s,
    do: acc

  def expand(<<"?", xs :: binary>>, [s| _s] = sol, prev, n, acc) when n >= s,
    do: expand("." <> xs, sol, prev, n, acc)
  def expand(<<"?", xs :: binary>>, sol, prev, n, acc),
    do: expand("." <> xs, sol, prev, n, expand("#" <> xs, sol, prev, n, acc))
  def expand(<<".", xs :: binary>>, [_| sol], "#", _n, acc),
    do: expand(xs, sol, ".", 0, acc)
  def expand(<<".", xs :: binary>>, sol, _, _n, acc),
    do: expand(xs, sol, ".", 0, acc)
  def expand(<<"#", xs :: binary>>, sol, _prev, n, acc),
    do: expand(xs, sol, "#", n + 1, acc)

  # def memoized(key, fun) do
  #   with nil <- Process.get(key) do
  #     fun.() |> tap(&Process.put(key, &1))
  #   end
  # end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D12.run(input, 5)

IO.puts(result)
