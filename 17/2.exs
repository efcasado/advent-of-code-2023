defmodule AOC23.D17 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]
  
  def run(input) do
    {size, g} =
      parse(input)
    
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
    {{w, {u, {steps, _} = cons}}, q} = min(q0)
    case steps >= 4 and t == u do
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
          # reject out of range
          []
        dir == new_dir ->
          # same direction
          [{new_pos, {steps + 1, new_dir}}]
        r180(new_dir) == dir ->
          # reject reverse
          []
        steps == 0 or steps >= 4 ->
          # change direction
          [{new_pos, {1, new_dir}}]
        true ->
          []
      end
    end)
    |> Enum.reject(fn({_v, {steps, _dir}}) -> steps > 10 end)
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

    m = Map.new(rs)
    
    {{{1, i - 1}, {1, j}}, m}
  end

  def l2cs(line, n) do
    line
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.with_index(fn(e, idx) -> {{n, idx + 1}, String.to_integer(e)} end)
  end

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}

  def r180({i, j}), do: {-i, -j}
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D17.run(input)

IO.puts(result)
