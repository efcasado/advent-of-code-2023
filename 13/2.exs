defmodule AOC23.D13 do
  def run(input) do
    patterns = parse(input)

    cols =
    patterns
    |> Enum.reduce(0,
    fn(p, acc) ->
      acc + mirror(p)
    end)

    rows =
    patterns
    |> Enum.reduce(0,
    fn(p, acc) ->
      acc + mirror(rotate(p))
    end)

    rows * 100 + cols
  end

  def parse(input) do
    {p, ps} =
      input
      |> Enum.reduce({[], []},
      fn
        ("\n", {p, ps}) ->
          {[], [p| ps]}
        (line0, {p, ps}) ->
          line =
            line0
            |> String.trim
            |> String.split("", trim: :true)
          {[line| p], ps}
      end)
    [p| ps]
  end

  def rotate([[] | _]), do: []
  def rotate(m),        do: [Enum.reverse(Enum.map(m, &hd/1)) | rotate(Enum.map(m, &tl/1))]


  def mirror(pattern) do
    pattern
    #|> IO.inspect
    |> Enum.map(fn(line) -> reflections(line) end)
    |> common
  end

  def common(xs) do
    cs =
    xs
    #|> IO.inspect
    |> List.flatten
    #|> IO.inspect
    |> Enum.map(fn({x, _n}) -> x end)
    # all possible candidates
    |> Enum.uniq
    #|> IO.inspect
    # only those present in all lines
    |> Enum.filter(fn(x) -> Enum.all?(xs, fn(rs) -> Enum.member?(Enum.map(rs, fn({x, _}) -> x end), x) end) end)
    #|> IO.inspect
    # only the ones with defects
    |> Enum.map(fn(c) -> Enum.filter(List.flatten(xs), fn({^c, 1}) -> true; (_) -> false end) end)
    #|> IO.inspect
    # only the ones with one defect
    |> Enum.filter(fn([_]) -> true; (_) -> false end)
    #|> IO.inspect

    case cs do
      []         -> 0
      [[{c, 1}]] -> c
    end
  end


  def reflections(xs, acc \\ [], ms \\ [])
  def reflections([],      _acc,       ms) do
    ms
  end
  def reflections([x| xs] = xs0, acc, ms) do
    case reflects?(xs0, acc) do
      {true, n}  -> reflections(xs, [x| acc], [{Enum.count(acc), n}| ms])
      false -> reflections(xs, [x| acc], ms)
    end
  end

  def reflects?(x, y, n \\ 0, s \\ 0)

  def reflects?(      _,      [],  0, _), do: false
  def reflects?(     [],      _y,  0, _), do: false
  def reflects?(      _,      [], _n, 0), do: {true, 0}
  def reflects?(     [],      _y, _n, 0), do: {true, 0}
  def reflects?(      _,      [], _n, 1), do: {true, 1}
  def reflects?(     [],      _y, _n, 1), do: {true, 1}
  def reflects?(      _,      [], _n, _), do: false
  def reflects?(     [],      _y, _n, _), do: false
  def reflects?([e| xs], [e| ys],  n, s), do: reflects?(xs, ys, n + 1, s)
  def reflects?([_| xs], [_| ys],  n, s), do: reflects?(xs, ys, n + 1, s + 1)
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D13.run(input)

IO.puts(result)
