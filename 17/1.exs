defmodule AOC23.D17 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]
  
  def run(input) do
    {size, g} =
      parse(input)
      # |> IO.inspect(limit: :infinity)
    
    s = source(size)
    t = target(size)

    distance(g, s, t)
  end

  def distance(g, from, to) do
    distances(g, from, to)
  end

  def distances(g, from, to) do
    distances(g, to, :gb_sets.singleton({0, {from, {0, {0, 0}}}}), MapSet.new())
  end

  def distances(g, t, q0, seen) do
    {{w, {u, cons}}, q} = min(q0)
    case t == u do
      true ->
        w
      false ->
        ns = neighbors(g, u, cons)
        |> Enum.reject(&(MapSet.member?(seen, &1))) # filter out neighbors already visited

        seen1 = Enum.reduce(ns, seen, &(MapSet.put(&2, &1)))

        q1  = Enum.reduce(ns, q,
          fn({v, cons}, q) ->
            dv = g[v]
            alt = dv + w
            addwp(q, {v, alt, cons})
          end)
        distances(g, t, q1, seen1)
    end
  end

  def min(q), do: :gb_sets.take_smallest(q)

  def addwp(q, {v1, w, cons}), do: :gb_sets.add({w, {v1, cons}}, q)

  def neighbors(g, u, {steps, dir} = _cons) do
    Enum.flat_map(@directions, fn(new_dir) ->
      new_pos = vadd(u, new_dir)
      cond do
        Map.get(g, new_pos) === nil ->
          []
        dir === new_dir ->
          [{new_pos, {steps + 1, new_dir}}]
        r180(new_dir) === dir ->
          []
        true ->
          [{new_pos, {1, new_dir}}]
      end
    end)
    |> Enum.reject(fn({_v, {steps, _dir}}) -> steps > 3 end)
  end
  
  def source({{i, _}, {j, _}}), do: {i, j}
  def target({{_, i}, {_, j}}), do: {i, j}
  
  def parse(input) do
    {{i, j}, rs} =
      input
      |> Enum.reduce({{1, 1}, []},
      fn(line, {{i, _j}, rs}) ->
        r = l2cs(line, i)
        j = Enum.count(r)
        {{i + 1, j}, r ++ rs}
      end)

    m0 = Map.new(rs)
    # m1 = Map.new(Enum.map(m0, fn({k, {w, ns}}) -> {k, {w, Enum.filter(ns, &(validn?(m0, &1)))}} end))
    
    {{{1, i - 1}, {1, j}}, m0}
  end

  def l2cs(line, n) do
    line
    |> String.trim
    |> String.split("", trim: true)
    # |> Enum.with_index(fn(e, idx) -> {{n, idx + 1}, {String.to_integer(e), neighbors({n, idx + 1})}} end)
    |> Enum.with_index(fn(e, idx) -> {{n, idx + 1}, String.to_integer(e)} end)
  end

  # def neighbors(p), do: Enum.map([@up, @down, @left, @right], &({&1, vadd(p, &1)}))

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def r180({i, j}), do: {-i, -j}
  
  # def validn?(m, {_, n}), do: Map.get(m, n, nil) != nil
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D17.run(input)

IO.puts(result)
