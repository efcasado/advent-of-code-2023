defmodule AOC23.D21 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]

  def run(input) do
    {size, start, m} = parse(input)
    #|> IO.inspect(limit: :infinity)

    bfs(size, m, [{start, 0}], 100, MapSet.new())
    #|> IO.inspect
    |> Enum.count
  end

  def bfs(_size, _m, [{_p, s}| _], limit, seen) when s > limit do
    Enum.filter(seen, fn({_p, s}) -> s == limit end)
  end
  def bfs(size, m, [{p, s} = n| ns0], limit, seen) do
    case MapSet.member?(seen, n) do
      true  ->
        bfs(size, m, ns0, limit, seen)
      false ->
        ns1 = Enum.map(neighbors(m, size, p), fn(e) -> {e, s + 1} end)
        bfs(size, m, ns0 ++ ns1, limit, MapSet.put(seen, n))
    end
  end

  def neighbors(m, size, p) do
    {p, {oi, oj}} = p(size, p)
    Enum.map(m[p], fn({i, j}) -> {i + oi, j + oj} end)
  end
  
  def parse(input) do
    {{i, j}, start, rs} = input
    |> Enum.reduce({{1, 1}, {-1, -1}, []}, fn(line, {{i, _j}, start0, rs}) ->
      r = l2cs(line, i)
      j = Enum.count(r)
      r = Enum.reject(r, fn(nil) -> true; (_) -> false end)
      start =
        case start(line) do
          [] ->
            start0
          [c] ->
            {i, c}
        end
      {{i + 1, j}, start, r ++ rs}
    end)

    size = {{1, i - 1}, {1, j}}
    m0 = Map.new(rs)
    m1 = Map.new(Enum.map(m0, fn({k, ns}) -> {k, Enum.filter(ns, &(validn?(size, m0, &1)))} end))
    {size, start, m1}
  end

  def p({ii, jj}, {i, j}) do
    {new_i, i_offset} = xy(ii, i)
    {new_j, j_offset} = xy(jj, j)
    {{new_i, new_j}, {i_offset, j_offset}}
  end

  def xy({_min, max}, v0) when v0 > max do
    v1 = rem(v0 - 1, max) + 1
    {v1, max * div(v0 - 1, max)}
  end
  def xy({min, max}, v0) when v0 < min do
    # {p, _offset} = xy({min, max}, max - v)
    # {p, 0}
    ## {rem(v0, max) + max, v0 - 1}
    v1 = rem(v0, max) + max
    {v1, max * (div(v0, max) - 1)}
  end
  def xy(_size, v) do
    {v, 0}
  end
  
  def validn?(size, m, p0) do
    {p1, _offset} = p(size, p0)
    Map.get(m, p1, nil) != nil
  end

  def start(line) do
    line
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.with_index(fn("S", idx) -> idx + 1; (_, _) -> nil end)
    |> Enum.reject(fn(e) -> e == nil end)
  end
  
  def l2cs(line, n) do
    line
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.with_index(fn("#", _) -> nil; (_, idx) -> {{n, idx + 1}, neighbors({n, idx + 1})} end)
  end

  def neighbors(p), do: Enum.map(@directions, &(vadd(p, &1)))

  def vadd({i1, j1}, {i2, j2}), do: {i1 + i2, j1 + j2}
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D21.run(input)

IO.puts(result)
