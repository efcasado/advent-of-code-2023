defmodule AOC23.D25 do
  def run(input) do
    {3, _mc, g1, g2} = parse(input)
    |> mincut(1_000, 3)

    Enum.count(g1) * Enum.count(g2)
  end

  def mincut(g, iters \\ 10, target \\ nil) do
    nedges = Enum.count(edges(g))
    _mincut(g, {nedges, %{}, %{}, %{}}, target, iters)
  end

  def _mincut(_g, min, _target, 0) do
    min
  end
  def _mincut(_g, {target, _, _, _} = min, target, _iters) do
    min
  end
  def _mincut(g0, min, target, iters) do
    g1 = contract(g0)

    [vs1, vs2] = Enum.map(g1, fn({v, _es}) -> String.split(v, "-") end)
    gg1 = Enum.map(vs1, fn(v) -> {v, Enum.reject(Map.get(g0, v, []), &(Enum.member?(vs2, &1)))} end)
    gg2 = Enum.map(vs2, fn(v) -> {v, Enum.reject(Map.get(g0, v, []), &(Enum.member?(vs1, &1)))} end)

    cs = edges(g0) -- (edges(gg1) ++ edges(gg2))
    |> Enum.count
    |> div(2)

    _mincut(g0, min(min, {cs, g1, gg1, gg2}), target, iters - 1)
  end

  def edges(g), do: Enum.flat_map(g, fn({v, es}) -> Enum.map(es, &({v, &1})) end)

  def contract(g) when map_size(g) == 2 do
    g
  end
  def contract(g) do
    {v1, es1} = Enum.random(g)
    v2 = Enum.random(es1)
    es2 = g[v2]

    # new node
    v3  = Enum.join([v1, v2], "-")
    es1 = MapSet.delete(es1, v2)
    g = Enum.reduce(es1, g, fn(v, g) -> Map.update!(g, v, &(MapSet.put(MapSet.delete(&1, v1), v3))) end)
    es2 = MapSet.delete(es2, v1)
    g = Enum.reduce(es2, g, fn(v, g) -> Map.update!(g, v, &(MapSet.put(MapSet.delete(&1, v2), v3))) end)
    es3 = MapSet.union(es1, es2)

    g
    |> Map.put(v3, es3)
    |> Map.delete(v1)
    |> Map.delete(v2)
    |> contract
  end

  def parse(input) do
    input
    |> Enum.flat_map(fn(line) ->
      [from, to] = line
      |> String.trim
      |> String.split(": ", trim: true)

      to = String.split(to, " ", trim: :true)
      [{from, to}| Enum.map(to, &({&1, [from]}))]
    end)
    |> Enum.reduce(%{}, fn({k, v}, g) ->
      Map.update(g, k, MapSet.new(v), &(MapSet.union(&1, MapSet.new(v))))
    end)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D25.run(input)

IO.puts(result)
