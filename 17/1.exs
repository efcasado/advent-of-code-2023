defmodule AOC23.D17 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}

  def run(input) do
    {size, g} =
      parse(input)
      # |> IO.inspect(limit: :infinity)
    
    s = source(size)
    t = target(size)

    distance(g, s, t)
  end

  def distance(g, from, to) do
    {dist, prev} = distances(g, from, to)
    #|> IO.inspect(limit: :infinity)
    trail(prev, from, to, [to])
    |> IO.inspect
    dist[to]
  end

  def trail(_m, to, to, acc) do
    acc
  end
  def trail(m, from, to, acc) do
    p = m[to]
    trail(m, from, p, [p| acc])
  end
  
  def distances(g, from, to) do
    # TODO: Initialize steps and direction
    distances(g, to, [{from, 0, {3, {0, 0}}, {0, 0}}], %{from => 0}, %{})
  end

  def distances(_g, _t, [], dist, prev) do
    {dist, prev}
  end
  def distances(g, t, q0, dist, prev) do
    {{u, _w, cons, _from}, q} = min(q0)
    #|> IO.inspect
    #IO.puts "u=#{inspect u}"
    
    #case t == u do
    #  true ->
    #    {dist, prev}
    #  false ->
        ns = neighbors(g, u, cons)
        {dist1, prev1, q1} =
          Enum.reduce(ns, {dist, prev, q},
            fn({v, w, cons}, {d, p, q}) ->
              alt = d[u] + w
              #IO.puts "v=#{inspect v} | d[u]=#{d[u]} w=#{w} d[v]=#{inspect d[v]} | #{alt}"
              case alt < d[v] do
                # TODO: Use proper priority queue
                true  -> {Map.put(d, v, alt), Map.put(p, v, u), addwp(q, {v, alt, cons, u})}
                false -> {d, p, q}
              end
            end)
        distances(g, t, q1, dist1, prev1)
    #end
  end

  def min(q) do
    # TODO: Use proper priority queue
    #IO.puts "Q | q=#{inspect q}"
    # fetch the element with the minimum weight
    u = Enum.min(q, fn({_, w1, _, _}, {_, w2, _, _}) -> w1 <= w2 end)
    {e, _, _, _} = u
    #IO.puts "Q | min=#{inspect e}"
    {u, q -- [u]}
  end

  # node = pos, weight, constraint, prev pos
  def addwp(q, {v1, _w, _cons, _u} = e1) do
    #IO.puts "adding #{inspect v1} to #{inspect q}"
    # TODO: Use proper priority queue
    case Enum.any?(q, fn({v0, _, _, _}) -> v1 == v0 end) do
      true  ->
        Enum.map(q, fn({^v1, _, _, _} = e0) -> IO.puts "replace old=#{inspect e0} new=#{inspect e1}"; e1; (e0) -> e0 end)
      false -> [e1| q]
    end
    #[e1| q]
  end
  
  def neighbors(g, u, {steps, pdir} = _cons) do
    {_w, ns} = Map.get(g, u) # fetch u's neighbors
    xxx =
    Enum.map(ns, fn({d, n}) ->
      {w, _ns} = Map.get(g, n)
      #cdir = vsub(u, n)
      case pdir == d do
        true  -> {n, w, {steps - 1, d}}
        false -> {n, w, {3, d}}
      end
    end)
    # filter out neighbours that are unreachable due to constraint
    #|> IO.inspect
    |> Enum.filter(fn({_n, _w, {s, _d}}) -> s > 0 end)
    #|> IO.inspect
    #IO.puts "u=#{inspect u} ns=#{inspect xxx}"
    xxx
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
    m1 = Map.new(Enum.map(m0, fn({k, {w, ns}}) -> {k, {w, Enum.filter(ns, &(validn?(m0, &1)))}} end))
    
    {{{1, i - 1}, {1, j}}, m1}
  end

  def l2cs(line, n) do
    line
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.with_index(fn(e, idx) -> {{n, idx + 1}, {String.to_integer(e), neighbors({n, idx + 1})}} end)
  end

  #def neighbors(p), do: Enum.map([@up, @down, @left, @right], &(vadd(p, &1)))
  def neighbors(p), do: Enum.map([@up, @down, @left, @right], &({&1, vadd(p, &1)}))

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}
  def vsub({i1, j1}, {i2, j2}), do: {i2 - i1, j2 - j1}

  #def validn?(m, n), do: Map.get(m, n, nil) != nil
  def validn?(m, {_, n}), do: Map.get(m, n, nil) != nil
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D17.run(input)

IO.puts(result)
