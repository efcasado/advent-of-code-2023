defmodule AOC23.D17 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}

  def run(input, s, d) do
    {size, g} =
      parse(input)
      |> IO.inspect(limit: :infinity)
    
    s = source(size)
    t = target(size)

    IO.puts "from=#{inspect s} to=#{inspect t}"
    distance(g, s, t)
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
  
  def distance(_g, _from, _to) do
    0
  end

  def neighbors(_u, _steps, _direction) do
    []
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D17.run(input, {1, 0}, {0, 1})

IO.puts(result)
