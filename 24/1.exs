defmodule AOC23.D24 do
  def run(input, min, max) do
    _hailstones = parse(input)
    # |> IO.inspect(limit: :infinity)
    |> intersect
    #|> IO.inspect(limit: :infinity)
    |> Enum.filter(fn({{_, _}, {px, py}}) ->
      min < px and px < max and min < py and py < max
    end)
    |> Enum.count
  end

  def intersect(xs, acc \\ [])
  def intersect([], acc) do
    acc
  end
  def intersect([h| tail], acc0) do
    acc1 = tail
    |> Enum.reduce([], fn(x, acc) ->
      case intersect?(h, x) do
        false -> acc
        {true, p}  -> [{{h, x}, p}| acc]
      end
    end)
    |> Kernel.++(acc0)

    intersect(tail, acc1)
  end

  def intersect?({_, {_a, {ux, uy, _uz}}}, {_id2, {_b, {vx, vy, _vz}}})
  when (ux * vy - uy * vx) == 0 do
     false
  end
  def intersect?({_, {{ax, ay, _az}, {ux, uy, _uz}}}, {_, {{bx, by, _bz}, {vx, vy, _vz}}}) do
    t = ((bx - ax) * vy - (by - ay) * vx) / (ux * vy - uy * vx)
    u = ((bx - ax) * uy - (by - ay) * ux) / (ux * vy - uy * vx)
    case t < 0 or u < 0 do
      true  -> false
      false -> {true, {ax + t * ux, ay + t * uy}}
    end
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
# result    = AOC23.D24.run(input, 7, 17)
result    = AOC23.D24.run(input, 200_000_000_000_000, 400_000_000_000_000)

IO.puts(result)
