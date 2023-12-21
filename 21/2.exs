defmodule AOC23.D21 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]

  # sample_input 11x11
  # w 11
  # new grids at round(w / 2) + 1 = 6
  # 1  ->  2  (2) 0
  # 2  ->  4  (4) 0
  # 3  ->  6  (6) 0
  # 4  ->  9  (9) 0
  # ...
  # 6  -> 16 (16) 0
  # 7  -> 21 (22) 1
  # ...
  # 13 -> 39 (89) 50
  # 14 -> 42 (99) 57
  #
  # input 131x131
  # w 131
  # new grids at round(w / 2) + 1 = 66
  # 1  ->    4    (4)
  # 2  ->    8    (8)
  # 3  ->   16   (16)
  # 4  ->   24   (24)
  # ...
  # 65 -> 3944 (3944)
  # 66 -> 4076 (4076)
  # 67 -> 4200 (4212)
  def run(input) do
    {size, start, m} = parse(input)
    #|> IO.inspect(limit: :infinity)

    # bfs(size, m, [{start, 0}], 16, MapSet.new())
    # |> enclosed(size)
    # |> IO.inspect
    # |> Enum.count
    # |> IO.inspect
    
    xxx(size, m, start, 1, 64, [])
    |> Enum.with_index(fn(x, idx) -> {idx + 1, Enum.count(enclosed(x, size)), Enum.count(x), div(Enum.count(x), 39), div(Enum.count(x), 42), grids(x, size)} end)
    |> IO.inspect(limit: :infinity)
    #|> diff(0, [])
    #|> IO.inspect(limit: :infinity)
    #|> diff(0, [])
    #|> IO.inspect(limit: :infinity)
    #|> Enum.count
    
    0
  end

  def enclosed(xs, {{i0, i1}, {j0, j1}}) do
    Enum.filter(xs, fn({i, j}) -> i >= i0 and i <= i1 and j >= j0 and j <= j1 end)
  end

  def grids(xs, {{_, max_i}, {_, max_j}}) do
    is = Enum.map(xs, fn({i, _}) -> i end)
    js = Enum.map(xs, fn({i, _}) -> i end)
    i0 = Enum.min(is)
    i1 = Enum.max(is)
    j0 = Enum.min(js)
    j1 = Enum.max(js)
    abs(floor((i0 - max_i) / max_i)) + floor(i1 / max_i) + abs(floor((j0 - max_j) / max_j)) + floor(j1 / max_j)
  end
  
  def diff([], _prev, acc) do
    Enum.reverse(acc)
  end
  def diff([x| xs], prev, acc) do
    diff(xs, x, [x - prev| acc])
  end
  
  def xxx(_size, _m, _start, steps, limit, acc) when steps > limit do
    Enum.reverse(acc)
  end
  def xxx(size, m, start, current, limit, acc) do
    res = bfs(size, m, [{start, 0}], current, MapSet.new())
    #|> enclosed(size)
    #|> Enum.count

    #IO.puts "steps=#{current} res=#{res} diff=#{res - prev}"
    xxx(size, m, start, current + 1, limit, [res| acc])
  end
  
  def find_cycle(x0, f) do
    lambda = find_lambda(f, x0, f.(x0), 1, 1)
    hare = Enum.reduce(1..lambda, x0, fn _,hare -> f.(hare) end)
    mu = find_mu(f, x0, hare, 0)
    {lambda, mu}
  end

  # Find lambda, the cycle length
  defp find_lambda(_, tortoise, hare, _, lambda) when tortoise==hare, do: lambda
  defp find_lambda(f, tortoise, hare, power, lambda) do
    if power == lambda, do: find_lambda(f, hare, f.(hare), power*2, 1),
                      else: find_lambda(f, tortoise, f.(hare), power, lambda+1)
  end

  # Find mu, the zero-based index of the start of the cycle
  defp find_mu(_, tortoise, hare, mu) when tortoise==hare, do: mu
  defp find_mu(f, tortoise, hare, mu) do
    find_mu(f, f.(tortoise), f.(hare), mu+1)
  end
  
  def bfs(_size, _m, [{_p, s}| _], limit, seen) when s > limit do
    seen
    |> Enum.filter(fn({_p, s}) -> s == limit end)
    |> Enum.map(fn({p, _s}) -> p end)
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
