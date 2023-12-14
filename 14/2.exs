defmodule AOC23.D14 do
  def run(input) do
    parse(input) # west
    |> IO.inspect
    |> cycle(1)
    #|> cycle(1_000_000_000)
    |> IO.inspect
    # point north
    # |> rotate
    # |> Enum.map(&(Enum.reverse(&1)))
    # |> load
    |> IO.inspect

    0
  end

  def cycle(m, n \\ 1)
  def cycle(m, 0) do
    m
  end
  def cycle(m0, n) do
    m =
    m0
    |> north
    |> west
    |> south
    |> east

    cycle(m, n - 1)
  end
  
  def load(xs) do
    xs
    |> Enum.map(&(Enum.filter(&1, fn({_, _, "O"}) -> true; (_) -> false end)))
    #|> IO.inspect
    |> List.flatten
    |> Enum.reduce(0, fn({from, n, _}, acc) -> acc + Enum.sum(from..(from-(n-1)))end)
  end

  def tilt(xs) do
    Enum.map(xs, &(tilt(&1, Enum.count(&1), Enum.count(&1), [])))
  end

  def tilt([], _p, _prev, acc) do
    acc
  end
  def tilt(["O"| xs], p, prev, [{prev, n, "O"} |as]) do
    tilt(xs, p - 1, prev, [{prev, n + 1, "O"}| as])
  end
  def tilt(["O"| xs], p, prev, as) do
    tilt(xs, p - 1, prev, [{prev, 1, "O"}| as])
  end
  def tilt(["#"| xs], p, _prev, acc) do
    tilt(xs, p - 1, p - 1, [{p, 1, "#"}| acc])
  end
  def tilt(["."| xs], p, prev, acc) do
    tilt(xs, p - 1, prev, acc)
  end

  def expand(xs) do
    Enum.map(xs, &(expand(&1, 0, [])))
  end

  def expand([], prev, acc) do
    gaps = List.duplicate(".", 10 - prev)
    gaps ++ acc
  end
  def expand([{p1, _, "#"}| ps], p0, acc) do
    gaps = List.duplicate(".", (p1 - p0 - 1))
    expand(ps, p1, ["#"| gaps ++ acc])
  end
  def expand([{p1, n, "O"}| ps], p0, acc) do
    gaps = List.duplicate(".", (p1 - p0 - n))
    expand(ps, p1, List.duplicate("O", n) ++ gaps ++ acc)
  end

  def parse(input) do
      input
      |> Enum.reduce([],
      fn (line, rs) ->
        r =
        line
        |> String.trim
        #|> IO.inspect
        |> String.split("", trim: :true)

        [r| rs]
      end)
      |> Enum.reverse
  end

  def rotate3(xs) do
    xs
    |> rotate
    |> rotate
    |> rotate
  end

  def rotate([[] | _]), do: []
  def rotate(m),        do: [Enum.reverse(Enum.map(m, &hd/1)) | rotate(Enum.map(m, &tl/1))]

  def north(m) do
    m
    |> rotate
    |> Enum.map(&(Enum.reverse(&1)))
    |> tilt
    |> expand
    |> Enum.map(&(Enum.reverse(&1)))
    |> rotate
    |> rotate
    |> rotate
  end

  def east(m) do
    m
    |> Enum.map(&(Enum.reverse(&1)))
    |> tilt
    |> expand
    |> Enum.map(&(Enum.reverse(&1)))
  end

  def south(m) do
    m
    |> rotate
    |> tilt
    |> expand
    |> rotate
    |> rotate
    |> rotate
  end


  def west(m) do
    m
    |> tilt
    |> expand
  end

end


input     = IO.stream(:stdio, :line)
result    = AOC23.D14.run(input)

IO.puts(result)
