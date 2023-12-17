defmodule AOC23.D17 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}

  def run(input) do
    {size, g} =
      parse(input)
      #|> IO.inspect(limit: :infinity)
    
    s = source(size)
    t = target(size)

    distance(g, s, t)
  end

  def distance(g, from, to) do
    {dist, _prev} = distances(g, from, to)
    #|> IO.inspect(limit: :infinity)

    dist[to]
  end

  def distances(g, from, to) do
    distances(g, to, [{from, 0}], %{from => 0}, %{})
  end

  def distances(_g, _t, [], dist, prev) do
    {dist, prev}
  end
  def distances(g, t, q0, dist, prev) do
    {u, q} = min(q0)
    case t == u do
      true ->
        {dist, prev}
      false ->
        ns = neighbors(g, u, 0, nil)
        {dist1, prev1, q1} =
          Enum.reduce(ns, {dist, prev, q},
            fn({v, w}, {d, p, q}) ->
              alt = d[u] + w
              case alt < d[v] do
                true  -> {Map.put(d, v, alt), Map.put(p, v, u), [{v, alt}| q]} # TODO: Use proper priority queue
                false -> {d, p, q}
              end
            end)
        distances(g, t, q1, dist1, prev1)
    end
  end

  def min(q) do
    # TODO: Use proper priority queue
    {u, w} = Enum.min(q)
    {u, q -- [{u, w}]}
  end
  
  def neighbors(g, u, _steps, _direction) do
    # TODO: Take steps and direction into account
    {_w, ns} = Map.get(g, u)
    Enum.map(ns, fn(n) -> {w, _ns} = Map.get(g, n); {n, w} end)
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

  def neighbors(p), do: Enum.map([@up, @down, @left, @right], &(vadd(p, &1)))

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def validn?(m, n), do: Map.get(m, n, nil) != nil
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D17.run(input)

IO.puts(result)
