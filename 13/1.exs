defmodule AOC23.D13 do
  def run(input) do
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

    cols =
    [p| ps]
    #|> IO.inspect
    |> Enum.map(fn(p) ->
      Enum.map(p, fn(line) ->
        mirror?(line)
      end)
      |> common
    end)
    #|> IO.inspect
    |> Enum.sum

    rows =
    [p| ps]
    |> Enum.map(fn(p) ->
      rotate(p)
      #|> IO.inspect
      |> Enum.map(fn(line) ->
        mirror?(line)
      end)
      |> common
    end)
    #|> IO.inspect
    |> Enum.sum

    rows * 100 + cols
  end

  def common(xs) do
    common =
      xs
      |> List.flatten
      |> Enum.uniq
      |> Enum.filter(fn(x) -> Enum.all?(xs, fn(ms) -> Enum.member?(ms, x) end) end)

    case common do
      [ ] -> 0
      [c] -> c
    end
  end

  def rotate([[] | _]), do: []
  def rotate(m),        do: [Enum.reverse(Enum.map(m, &hd/1)) | rotate(Enum.map(m, &tl/1))]

  def mirror?(xs, acc \\ [], ms \\ [])
  def mirror?([],      _acc,       ms) do
    ms
  end
  def mirror?([x| xs] = xs0, acc, ms) do
    case xxx?(xs0, acc) do
      true  -> mirror?(xs, [x| acc], [Enum.count(acc)| ms])#[{Enum.count(acc), acc, xs0}| ms])
      false -> mirror?(xs, [x| acc], ms)
    end
  end

  def xxx?(x, y, n \\ 0)

  def xxx?(      _,      [],  0), do: false
  def xxx?(     [],      _y,  0), do: false
  def xxx?(      _,      [], _n), do: true
  def xxx?(     [],      _y, _n), do: true
  def xxx?([e| xs], [e| ys],  n), do: xxx?(xs, ys, n + 1)
  def xxx?([_x| _], [_y| _], _n), do: false
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D13.run(input)

IO.puts(result)
