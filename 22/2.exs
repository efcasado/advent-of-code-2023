defmodule AOC23.D22 do
  def run(input) do
    bricks = parse(input)
    |> Enum.sort_by(fn({id, {_x, _y, {z1, z2}}}) -> {{z1, z2}, id} end)
    # |> IO.inspect
    |> fall
    # |> IO.inspect(limit: :infinity)

    {supports, critical} = bricks
    |> critical
    |> IO.inspect(limit: :infinity)

    # heights = heights_map(bricks)
    # xxx(heights, bricks, critical, 0)
    Enum.reduce(critical, 0, fn(c, acc) -> Enum.count(chain(supports, [c], [])) + acc end)
  end

  def heights_map(bricks) do
    bricks
    |> Enum.map(fn({id, {_x, _y, z}}) -> {id, z} end)
    |> Map.new
  end

  def xxx(_heights, _bricks, [], acc) do
    acc
  end
  def xxx(heights0, bricks, [c| cs], acc) do
    heights1 = bricks -- [c]
    |> fall
    |> heights_map()

    moves = heights1
    |> Enum.filter(fn({k, v}) -> heights0[k] != v end)
    |> Enum.count

    xxx(heights0, bricks, cs, moves + acc)
  end

  def chain(m, k, acc) do
    case m[k] do
      nil -> List.flatten(acc)
      v   -> chain(m, v, [v| acc])
    end
  end

  def critical(bricks) do
    _critical(bricks, bricks, [], [])
  end

  def _critical([], _all, acc1, acc2) do
    acc2 = Enum.uniq(acc2)
    acc1 = Enum.reduce(acc1, %{}, fn({id, ids}, acc) -> Map.update(acc, id, ids, fn(ids0) -> ids ++ ids0 end) end)
    {acc1, acc2}
  end
  def _critical([{id1, _} = b| bs1], all, acc1, acc2) do
    case Enum.filter(all, fn(b2) -> supported?(b, b2) end) do
      []         -> _critical(bs1, all, acc1, acc2)
      [{id2, _}] -> _critical(bs1, all, [{[id2], [id1]}| acc1], [id2| acc2])
      xxx        -> _critical(bs1, all, [{Enum.map(xxx, fn({id, _}) -> id end), [id1]}| acc1], acc2)
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
