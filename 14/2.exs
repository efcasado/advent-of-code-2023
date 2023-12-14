defmodule AOC23.D14 do
  def run(input) do
    grid = parse(input) # west

    {clength, cstart} = find_cycle(grid, &cycle/1)

    iters = cstart + rem(1_000_000_000 - cstart, clength)

    grid
    |> cycle(iters)
    #|> IO.inspect
    |> load
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

  def find_cycle(x0, f) do
    lambda = find_lambda(f, x0, f.(x0), 1, 1)
    hare = Enum.reduce(1..lambda, x0, fn _,hare -> f.(hare) end)
    mu = find_mu(f, x0, hare, 0)
    {lambda, mu}
  end

  # Find lambda, the cycle length
  defp find_lambda(_, tortoise, hare, _, lambda) when tortoise==hare, do: lambda
  defp find_lambda(f, tortoise, hare, power, lambda) do
    if power == lambda, do: find_lambda(f, hare, f.(hare), power*2, 1),
                      else: find_lambda(f, tortoise, f.(hare), power, lambda+1)
  end

  # Find mu, the zero-based index of the start of the cycle
  defp find_mu(_, tortoise, hare, mu) when tortoise==hare, do: mu
  defp find_mu(f, tortoise, hare, mu) do
    find_mu(f, f.(tortoise), f.(hare), mu+1)
  end

  def load(m) do
    {_, xs} =
    m
    |> Enum.reduce({Enum.count(m), []}, fn(r, {n, acc}) -> {n - 1, [n * Enum.count(Enum.filter(r, fn(x) -> x == "O" end))| acc]} end)

    Enum.sum(xs)
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

  def expand(xs, length) do
    Enum.map(xs, &(expand(&1, 0, length, [])))
  end

  def expand([], prev, length, acc) do
    gaps = List.duplicate(".", length - prev)
    gaps ++ acc
  end
  def expand([{p1, _, "#"}| ps], p0, length, acc) do
    gaps = List.duplicate(".", (p1 - p0 - 1))
    expand(ps, p1, length, ["#"| gaps ++ acc])
  end
  def expand([{p1, n, "O"}| ps], p0, length, acc) do
    gaps = List.duplicate(".", (p1 - p0 - n))
    expand(ps, p1, length, List.duplicate("O", n) ++ gaps ++ acc)
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

  def rotate([[] | _]), do: []
  def rotate(m),        do: [Enum.reverse(Enum.map(m, &hd/1)) | rotate(Enum.map(m, &tl/1))]

  def north(m) do
    [r| _] = m
    length = Enum.count(r)

    m
    |> rotate
    |> Enum.map(&(Enum.reverse(&1)))
    |> tilt
    |> expand(length)
    |> Enum.map(&(Enum.reverse(&1)))
    |> rotate
    |> rotate
    |> rotate
  end

  def east(m) do
    [r| _] = m
    length = Enum.count(r)

    m
    |> Enum.map(&(Enum.reverse(&1)))
    |> tilt
    |> expand(length)
    |> Enum.map(&(Enum.reverse(&1)))
  end

  def south(m) do
    [r| _] = m
    length = Enum.count(r)

    m
    |> rotate
    |> tilt
    |> expand(length)
    |> rotate
    |> rotate
    |> rotate
  end


  def west(m) do
    [r| _] = m
    length = Enum.count(r)

    m
    |> tilt
    |> expand(length)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D14.run(input)

IO.puts(result)
