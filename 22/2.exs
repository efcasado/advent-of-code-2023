defmodule AOC23.D22 do
  def run(input) do
    bricks = parse(input)
    |> Enum.sort_by(fn({id, {_x, _y, {z1, z2}}}) -> {{z1, z2}, id} end)
    # |> IO.inspect
    |> fall
    # |> IO.inspect(limit: :infinity)

    critical = bricks
    |> critical
    # |> IO.inspect(limit: :infinity)

    moves(bricks, critical)
  end

  def moves(bricks, critical) do
    heights = heights_map(bricks)

    pmap(critical, &(_moves(heights, bricks, &1)))
    |> Enum.sum
  end

  def pmap(xs, fun) do
    Task.async_stream(xs, fn(x) -> fun.(x) end, timeout: :infinity)
    |> Enum.map(fn({:ok, res}) -> res end)
  end

  def heights_map(bricks) do
    bricks
    |> Enum.map(fn({id, {_x, _y, z}}) -> {id, z} end)
    |> Map.new
  end


  def _moves(heights0, bricks, c) do
    bricks -- [c]
    |> fall
    |> heights_map()
    |> Enum.filter(fn({k, v}) -> heights0[k] != v end)
    |> Enum.count
  end

  def critical(bricks) do
    _critical(bricks, bricks, [])
  end

  def _critical([], _all, acc) do
    Enum.uniq(acc)
  end
  def _critical([b| bs1], all, acc) do
    case Enum.filter(all, fn(b2) -> supported?(b, b2) end) do
      [b3]       -> _critical(bs1, all, [b3| acc])
      _          -> _critical(bs1, all, acc)
    end
  end

  def supported?({id, _}, {id, _}) do
    false
  end
  def supported?({_id1, {x1, y1, {z11, z12}}}, {_id2, {x2, y2, {z21, z22}}}) do
    (z11 == z21 + 1 or z11 == z22 + 1 or z12 == z22 + 1 or z12 == z22 + 1) and overlap?(x1, x2) and overlap?(y1, y2)
  end

  def fall(bs, acc \\ [])
  def fall([], acc) do
    Enum.sort_by(acc, fn({id, {_x, _y, {z1, z2}}}) -> {{z1, z2}, id} end)
  end
  def fall([{id, {x, y, z}} = b1| bs1], acc) do
    case Enum.filter(acc, fn(b2) -> above?(b1, b2) end) do
      []  ->
        {z1, z2} = adjust_z([], z)
        fall(bs1, [{id, {x, y, {z1, z2}}}| acc])
      bs2 ->
        {z1, z2} = adjust_z(bs2, z)
        fall(bs1, [{id, {x, y, {z1, z2}}}| acc])
    end
  end

  def adjust_z([], {z1, z2}) do
    diff = z2 - z1

    {1, 1 + diff}
  end
  def adjust_z(bs, {z1, z2}) do
    diff = z2 - z1

    z1 = bs
    |> Enum.flat_map(fn({_id, {_x, _y, {z1, z2}}}) -> [z1, z2] end)
    |> Enum.max
    |> Kernel.+(1)

    {z1, z1 + diff}
  end

  def above?({id, _}, {id, _}) do
    false
  end
  def above?({_id1, {x1, y1, {z11, z12}}}, {_id2, {x2, y2, {z21, z22}}}) do
    (z11 > z21 or z12 > z22) and overlap?(x1, x2) and overlap?(y1, y2)
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
