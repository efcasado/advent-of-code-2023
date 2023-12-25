defmodule AOC23.D23 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]

  def run(input) do
    {_size, start, finish, grid} = parse(input)
    # |> IO.inspect(limit: :infinity)

    grid = compress(grid)

    longest(grid, [{start, 0, MapSet.new()}], finish, [])
  end

  def compress(grid) do
    # TODO: Handle weights
    grid
    |> compressx
    |> compressy
  end

  def compressx(grid) do
    {_, groups} = grid
    #|> IO.inspect(limit: :infinity)
    |> Enum.filter(&xcompressable?/1)
    |> Enum.sort
    #|> IO.inspect(limit: :infinity)
    |> Enum.reduce({{{-1, -1}, []}, []},
    fn
      ({{i, j}, ns}, {{{i, j0}, _}, [h| t]}) when j == (j0 + 1) ->
        {{{i, j}, ns}, [Enum.map(ns, fn({_w, n}) -> n end) ++ h| t]}
      ({{i, j}, ns}, {_, acc}) ->
        {{{i, j}, ns}, [[{i, j}] ++ Enum.map(ns, fn({_w, n}) -> n end)|acc]}
    end)
    #|> IO.inspect(limit: :infinity)

    groups
    |> Enum.reject(&(Enum.count(&1) == 3))
    #|> IO.inspect
    |> Enum.map(&({Enum.min(&1), Enum.max(&1)}))
    #|> IO.inspect
    |> Enum.reduce(grid, fn({{i, j0}, {i, j1}}, grid) ->
      (j0 + 1)..(j1 - 1)
      |> Enum.reduce(grid, &(Map.delete(&2, {i, &1})))
      |> Map.update({i, j0}, nil, fn(ns) ->
        (ns -- [{1, vadd({i, j0}, @right)}]) ++ [{j1 - j0, {i, j1}}]
      end)
      |> Map.update({i, j1}, nil, fn(ns) ->
        (ns -- [{1, vadd({i, j1}, @left)}]) ++ [{j1 - j0, {i, j0}}]
      end)
    end)
  end

  def compressy(grid) do
    {_, groups} = grid
    #|> IO.inspect(limit: :infinity)
    |> Enum.filter(&ycompressable?/1)
    |> Enum.sort
    #|> IO.inspect(limit: :infinity)
    |> Enum.reduce({{{-1, -1}, []}, []},
    fn
      ({{i, j}, ns}, {{{i0, j}, _}, [h| t]}) when i == (i0 + 1) ->
        {{{i, j}, ns}, [Enum.map(ns, fn({_w, n}) -> n end) ++ h| t]}
      ({{i, j}, ns}, {_, acc}) ->
        {{{i, j}, ns}, [[{i, j}] ++ Enum.map(ns, fn({_w, n}) -> n end)|acc]}
    end)
    #|> IO.inspect(limit: :infinity)

    groups
    |> Enum.reject(&(Enum.count(&1) == 3))
    #|> IO.inspect
    |> Enum.map(&({Enum.min(&1), Enum.max(&1)}))
    #|> IO.inspect
    |> Enum.reduce(grid, fn({{i0, j}, {i1, j}}, grid) ->
      (i0 + 1)..(i1 - 1)
      |> Enum.reduce(grid, &(Map.delete(&2, {&1, j})))
      |> Map.update({i0, j}, nil, fn(ns) ->
        (ns -- [{1, vadd({i0, j}, @down)}]) ++ [{i1 - i0, {i1, j}}]
      end)
      |> Map.update({i1, j}, nil, fn(ns) ->
        (ns -- [{1, vadd({i1, j}, @up)}]) ++ [{i1 - i0, {i1, j}}]
      end)
    end)
  end

  def xcompressable?({k, ns}), do: [{1, vadd(k, @left)}, {1, vadd(k, @right)}] == ns
  def ycompressable?({k, ns}), do: [{1, vadd(k,   @up)}, {1, vadd(k,  @down)}] == ns

  def longest(_m,                      [], _target, acc) do
    acc
    # |> IO.inspect
    |> Enum.max
  end
  def longest(m,  [{x, steps, _seen}| xs],       x, acc) do
    longest(m, xs, x, [steps| acc])
  end
  def longest(m,  [{x, steps,  seen}| xs],  target, acc) do
    seen = MapSet.put(seen, x)
    ns = m[x]
    |> Enum.reject(fn({_w, n}) -> MapSet.member?(seen, n) end)
    |> Enum.map(fn({w, n}) -> {n, steps + w, seen} end)
    longest(m, ns ++ xs, target, acc)
  end

  def parse(input) do
    {{i, j}, rs} = input
    |> Enum.reduce({{1, 1}, []}, fn(line, {{i, _j}, rs}) ->
      r = l2cs(line, i)
      j = Enum.count(r)
      r = Enum.reject(r, fn(nil) -> true; (_) -> false end)
      {{i + 1, j}, r ++ rs}
    end)

    m0 = Map.new(rs)
    m1 = Map.new(Enum.map(m0, fn({k, ns}) -> {k, Enum.filter(ns, fn({_w, n}) -> validn?(m0, n) end)} end))

    {start, _} = Enum.at(rs, -1)
    {finish, _} = Enum.at(rs, 0)

    {{{1, i - 1}, {1, j}}, start, finish, m1}
  end

  def validn?(m, p), do: Map.get(m, p, nil) != nil

  def l2cs(line, n) do
    line
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.with_index(fn
      ("#",   _) -> nil;
      # ("<", idx) -> {{n, idx + 1}, [vadd({n, idx + 1}, @left)]}
      # (">", idx) -> {{n, idx + 1}, [vadd({n, idx + 1}, @right)]}
      # ("^", idx) -> {{n, idx + 1}, [vadd({n, idx + 1}, @up)]}
      # ("v", idx) -> {{n, idx + 1}, [vadd({n, idx + 1}, @down)]}
      (  _, idx) -> {{n, idx + 1}, neighbors({n, idx + 1})}
    end)
  end

  def neighbors(p), do: Enum.map(@directions, &({1, vadd(p, &1)}))

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D23.run(input)

IO.puts(result)
