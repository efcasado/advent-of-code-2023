defmodule AOC23.D16 do
  @up    {-1,  0}
  @down  { 1,  0}
  @left  { 0, -1}
  @right { 0,  1}

  def run(input, s, d) do
    parse(input)
    |> traverse([{s, d}])
    |> Enum.map(fn({p, _d}) -> p end)
    |> Enum.uniq
    |> Enum.count
    |> Kernel.-(1)
  end

  def traverse(m, pd, visited \\ [])
  def traverse(_, [], trail) do
    trail
  end
  def traverse(m, [{p, d} = x| xs], trail) do
    case visited?(trail, x) do
      true  -> traverse(m, xs, trail)
      false -> traverse(m, next(m, p, d) ++ xs, [x| trail])
    end
  end

  def visited?(xs, x), do: Enum.member?(xs, x)

  def next(m, {i, j}, {x, y} = d) do
    p = {i + x, j + y}
    next2(Map.get(m, p, -1), p, d)
  end

  # out of range
  def next2(-1, _p, _d), do: []
  # .
  def next2(46, p, d), do: [{p, d}]
  # /
  def next2(47, p,    @up), do: [{p, @right}]
  def next2(47, p,  @down), do: [{p,  @left}]
  def next2(47, p, @right), do: [{p,    @up}]
  def next2(47, p,  @left), do: [{p,  @down}]
  # \
  def next2(92, p,    @up), do: [{p,  @left}]
  def next2(92, p,  @down), do: [{p, @right}]
  def next2(92, p, @right), do: [{p,  @down}]
  def next2(92, p,  @left), do: [{p,    @up}]
  # -
  def next2(45, p,  @left), do: [{p,  @left}]
  def next2(45, p, @right), do: [{p, @right}]
  def next2(45, p,    @up), do: [{p,  @left}, {p,  @right}]
  def next2(45, p,  @down), do: [{p,  @left}, {p,  @right}]
  # |
  def next2(124, p,    @up), do: [{p,   @up}]
  def next2(124, p,  @down), do: [{p, @down}]
  def next2(124, p,  @left), do: [{p,   @up}, {p, @down}]
  def next2(124, p, @right), do: [{p,   @up}, {p, @down}]

  def parse(input) do
    {_, m} =
    input
    |> Enum.reduce({{1, 1}, []}, fn(line, {{i, _j}, acc}) ->
      row =
        line
        |> String.trim
        |> String.to_charlist
        |> Enum.with_index(fn(e, j) -> {{i, j + 1}, e} end)
      j = Enum.count(row)
      {{i + 1, j}, row ++ acc}
    end)
    Map.new(m)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D16.run(input, {1, 0}, {0, 1})

IO.puts(result)
