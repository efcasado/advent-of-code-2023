defmodule AOC23.D24 do
  def run(input) do
    hs0 = parse(input)
    # |> IO.inspect(limit: :infinity)

    {norm, hs1} = normalize(hs0)
    # |> IO.inspect(limit: :infinity)
    rock = rock(hs1)
    # |> IO.inspect(limit: :infinity)

    [{"rock", {p1, _d1}}] = denormalize(norm, [rock])
    # |> IO.inspect(limit: :infinity)

    Enum.sum(Tuple.to_list(p1))
  end

  def normalize([h1| _hs] = hs) do
    {_, {p1, d1}} = h1
    {{p1, d1}, Enum.map(hs, fn({id, {p, d}}) -> {id, {vsub(p, p1), vsub(d, d1)}} end)}
  end

  def denormalize({p1, d1}= _norm, hs) do
    Enum.map(hs, fn({id, {p, d}}) -> {id, {vadd(p, p1), vadd(d, d1)}} end)
  end

  def rock([_h1, h2, h3, h4| _hs]) do
    {_, {p2, d2}} = h2
    {_, {p3, d3}} = h3
    {_, {p4, d4}} = h4

    # ax + by + cz = 0 is the plane common to all hailstones
    # n is the normal vector (x, y, z)
    n = cproduct(p2, vadd(p2, d2))
    #|> IO.inspect

    # https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection
    p0 = {0, 0, 0}
    {ip3, id3} = intersection(n, p0, p3, d3)
    #|> IO.inspect
    {ip4, id4} = intersection(n, p0, p4, d4)
    #|> IO.inspect

    iddiff = id4 - id3

    d = vsub(ip4, ip3) |> Tuple.to_list |> Enum.map(&(div(&1, iddiff))) |> List.to_tuple
    p = vsub(ip3, Tuple.to_list(d) |> Enum.map(&(&1 * id3)) |> List.to_tuple)
    {"rock", {p, d}}
  end

  def cproduct({x1, y1, z1}, {x2, y2, z2}) do
    {y1 * z2 - z1 * y2, z1 * x2 - z2 * x1, x1 * y2 - y1 * x2}
  end

  def dproduct({x1, y1, z1}, {x2, y2, z2}) do
    x1 * x2 + y1 * y2 + z1 * z2
  end

  def vadd({x1, y1, z1}, {x2, y2, z2}) do
    {x1 + x2, y1 + y2, z1 + z2}
  end

  def vsub({x1, y1, z1}, {x2, y2, z2}) do
    {x1 - x2, y1 - y2, z1 - z2}
  end

  def intersection(n, p0, l0, {lx, ly, lz} = l) do
    d = div(dproduct(vsub(p0, l0), n), dproduct(l, n))
    p = vadd(l0, {lx * d, ly * d, lz * d})
    {p, d}
  end

  def parse(input) do
    input
    |> Enum.map(fn(line) ->
      line
      |> String.trim
      |> String.split(" @ ", trim: true)
      |> Enum.map(fn(side) ->
        side
        |> String.split(", ", trim: true)
        |> Enum.map(&(String.to_integer(String.trim(&1))))
        |> List.to_tuple
      end)
      # |> Enum.zip
      |> List.to_tuple
    end)
    |> Enum.with_index(fn(e, idx) -> {id(idx, 2), e} end)
  end

  def id(n, size) do
    (size - 1)..0
    |> Enum.map(&(rem(div(n, 25**&1), 25)) + 65)
    |> to_string
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D24.run(input)

IO.puts(result)
