defmodule AOC23.D22 do
  def run(input) do
    _bricks = parse(input)
    #|> IO.inspect(limit: :infinity)
    |> Enum.sort_by(fn({_, {_x, _y, {z1, z2}}}) -> {z1, z2} end)
    #|> IO.inspect
    |> fall
    #|> IO.inspect
    |> removable
    |> IO.inspect(limit: :infinity)
    |> Enum.count
  end

  def removable(bricks) do
    _removable(bricks, bricks, [])
  end

  def _removable([_], _all, acc) do
    Enum.uniq(acc)
  end
  def _removable([b| bs1], all, acc) do
    case Enum.filter(all, fn(b2) -> atop2?(b, b2) end) do
      [_] -> _removable(bs1, all, acc)
      []  -> _removable(bs1, all, [b| acc])
      bs2 -> _removable(bs1, all, bs2 ++ acc)
    end
  end

  def atop2?({id, _}, {id, _}) do
    false
  end
  def atop2?({_id1, {x1, y1, {z11, z12}}}, {_id2, {x2, y2, {z21, z22}}}) do
    (z11 == z21 + 1 or z12 == z22 + 1) and overlap?(x1, x2) and overlap?(y1, y2)
  end

  def fall(bs, acc \\ [])
  def fall([], acc) do
    Enum.sort_by(acc, fn({_, {_x, _y, {z1, z2}}}) -> {z1, z2} end)
  end
  def fall([{id, {x, y, z}} = b1| bs1], acc) do
    case Enum.filter(acc, fn(b2) -> atop?(b1, b2) end) do
      []  -> fall(bs1, [{id, {x, y, {1, 1}}}| acc])
      bs2 ->
        {z1, z2} = adjust_z(bs2, z)
        fall(bs1, [{id, {x, y, {z1, z2}}}| acc])
    end
  end

  def adjust_z(bs, {z1, z2}) do
    diff = z2 - z1

    z1 = bs
    |> Enum.flat_map(fn({_id, {_x, _y, {z1, z2}}}) -> [z1, z2] end)
    |> Enum.max
    |> Kernel.+(1)

    {z1, z1 + diff}
  end

  def atop?({id, _}, {id, _}) do
    false
  end
  def atop?({_id1, {x1, y1, {z11, z12}}}, {_id2, {x2, y2, {z21, z22}}}) do
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
