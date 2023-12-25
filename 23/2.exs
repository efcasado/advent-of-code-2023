defmodule AOC23.D23 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]

  def run(input) do
    {_size, start, finish, grid} = parse(input)
    # |> IO.inspect(limit: :infinity)

    longest(grid, [{start, 0, MapSet.new()}], finish, [])
  end

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
    |> Enum.reject(&(MapSet.member?(seen, &1)))
    |> Enum.map(&({&1, steps + 1, seen}))
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
    m1 = Map.new(Enum.map(m0, fn({k, ns}) -> {k, Enum.filter(ns, &(validn?(m0, &1)))} end))

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

  def neighbors(p), do: Enum.map(@directions, &(vadd(p, &1)))

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D23.run(input)

IO.puts(result)
