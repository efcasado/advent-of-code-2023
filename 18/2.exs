defmodule AOC23.D18 do
  def run(input, start) do
    moves   = parse(input)

    polygon(moves, start)
    |> area(moves)

  end

  def parse(input) do
    input
    |> Enum.map(fn(line) ->
      [_d, _n, c] =
      line
      |> String.trim
      |> String.split(" ", trim: true)

      h2a(c)
    end)
  end

  def h2a(<<"(#", n0 :: binary-5, d :: binary-1, ")">>) do
    {n1, ""} = Integer.parse(n0, 16)
    {n2d(d), n1}
  end

  def n2d("0"), do: "R"
  def n2d("1"), do: "D"
  def n2d("2"), do: "L"
  def n2d("3"), do: "U"

  def polygon(moves, p0) do
    moves
    |> Enum.reduce([p0], fn({d, n}, [p| _] = ps) -> [move(p, d, n)| ps] end)
  end

  def area(ps, moves) do
    outer = div(Enum.reduce(moves, 0, fn({_d, n}, sum) -> sum + n end), 2)
    inner = shoelace(ps)
    outer + inner + 1
  end

  def shoelace(ps) do
    ps
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn([{i1, j1}, {i2, j2}], sum) ->
      sum + ((i1 - i2) * (j1 + j2))
    end)
    |> div(2)
    |> abs
  end

  def move({i, j}, "U", n), do: {i - n,     j}
  def move({i, j}, "D", n), do: {i + n,     j}
  def move({i, j}, "L", n), do: {i    , j - n}
  def move({i, j}, "R", n), do: {i    , j + n}
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D18.run(input, {1, 1})

IO.puts(result)
