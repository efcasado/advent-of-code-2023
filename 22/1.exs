defmodule AOC23.D22 do
  def run(input) do
    bricks = parse(input)
    #|> IO.inspect(limit: :infinity)
    |> Enum.sort_by(fn({_, {_x, _y, {z1, z2}}}) -> {z1, z2} end)
    |> IO.inspect
    #|> fall

    0
  end

  def fall([_]) do
    :ok
  end
  def fall([a, b| xs]) do
    atop?(b, a)
    |> IO.inspect
    fall([b| xs])
  end

  def atop?({_id1, {x1, y1, _z1}}, {_id2, {x2, y2, _z2}}) do
    overlap?(x1, x2) and overlap?(y1, y2)
  end

  def overlap?({a1, a2}, {b1, b2}), do: not Range.disjoint?(a1..a2, b1..b2)

  def parse(input) do
    input
    |> Enum.map(fn(line) ->
      line
      |> String.trim
      |> String.split("~", trim: true)
      |> Enum.map(fn(side) ->
        side
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.zip
      |> List.to_tuple
    end)
    |> Enum.with_index(fn(e, idx) -> {id(idx, 3), e} end)
  end


  def id(n, size) do
    (size - 1)..0
    |> Enum.map(&(rem(div(n, 25**&1), 25)) + 65)
    |> to_string
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D22.run(input)

IO.puts(result)
