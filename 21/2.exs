defmodule AOC23.D21 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}
  @directions [@up, @down, @left, @right]

  # Inspired by
  # https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
  #
  # 26501365 = 65 + (202300 * 131)
  # 65 is distance from the center
  # 131 is the width of the grid
  #
  #
  # total = (n + 1)**2 * Of + n**2 * Ef - (n - 1)**2 * Oc + n * Ec
  #
  #            O
  #          O E O
  #        O E O E O
  #          O E O
  #            O
  #
  #      n=0 1 (odd);  0 even
  #      n=1 1 (odd);  4 even
  #      n=2 9 (odd);  4 even => (n+1)**2 + n**2
  #      n=3 9 (odd); 16 even => n**2 + (n+1)**2
  def run(input) do
    {size, start, m} = parse(input)
    #|> IO.inspect(limit: :infinity)

    paths = shortest_paths(m, [{start, 0}], MapSet.new(), [])
    # alternative part 1
    #|> Enum.filter(fn({p, d}) -> (d <= 64) and rem(d, 2) == 0 end)
    #|> Enum.count
    #|> IO.inspect

    n0 = 26_501_365
    {{1, w}, {1, w}} = size
    n1 = div(n0 - div(w, 2), w)

    of = paths
    |> Enum.filter(fn({_p, d}) -> (rem(d, 2) != 0) end)
    |> Enum.count

    ef = paths
    |> Enum.filter(fn({_p, d}) -> (rem(d, 2) == 0) end)
    |> Enum.count

    oc = paths
    |> Enum.filter(fn({_p, d}) -> (d > 65 and rem(d, 2) != 0) end)
    |> Enum.count


    ec = paths
    |> Enum.filter(fn({_p, d}) -> (d > 65 and rem(d, 2) == 0) end)
    |> Enum.count

    cells(n1, of, ef, oc, ec)
  end

  def cells(n, of, ef, oc, ec) do
    (n + 1)**2 * of + n**2 * ef - (n + 1) * oc + n * ec
  end

  def shortest_paths(_m, [], _seen, paths) do
    paths
    #|> IO.inspect
    |> Enum.reduce(%{}, fn({k, v}, m) -> Map.update(m, k, [v], fn(v0) -> [v| v0] end) end)
    |> Enum.map(fn({k, vs}) -> {k, Enum.min(vs)} end)
  end
  def shortest_paths(m, [{p, s}| ns0], seen, paths) do
    case MapSet.member?(seen, p) do
      true  ->
        shortest_paths(m, ns0, seen, paths)
      false ->
        ns1 = Enum.map(m[p], fn(e) -> {e, s + 1} end)
        shortest_paths(m, ns0 ++ ns1, MapSet.put(seen, p), [{p, s}| paths])
    end
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

    m0 = Map.new(rs)
    m1 = Map.new(Enum.map(m0, fn({k, ns}) -> {k, Enum.filter(ns, &(validn?(m0, &1)))} end))
    {{{1, i - 1}, {1, j}}, start, m1}
  end

  def validn?(m, p), do: Map.get(m, p, nil) != nil

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
