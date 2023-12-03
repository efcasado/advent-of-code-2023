defmodule AOC23.D03 do
  def run(input) do
    {_lines, d, ps} =
    input
    |>  Enum.reduce(
      {0, %{}, []},
    fn(line, {i, acc0, spos0}) ->
      line = String.trim(line)

      # numbers
      ns = Regex.scan(~r/\d+/, line, return: :binary)
      ps = Regex.scan(~r/\d+/, line, return: :index)
      acc1 = xxx(ns, ps, i, input, acc0)

      # symbols
      ss = Regex.scan(~r/[^\d|\.]{1}/, line, return: :index)
      spos1 = yyy(ss, i, spos0)

      {i + 1, acc1, spos1}
    end)

    ps
    |> Enum.reduce(0,
    fn(p, acc) ->
      acc + Enum.sum(Map.get(d, p, [0]))
    end)
  end

  def yyy(nil, _i, acc) do
    acc
  end
  def yyy([], _i, acc) do
    acc
  end
  def yyy([[{j, _}] |ss], i, acc) do
    yyy(ss, i, [{i, j}| acc])
  end

  def xxx(nil, _ps, _i, _input, acc) do
    acc
  end
  def xxx([], _ps, _i, _input, acc) do
    acc
  end
  def xxx([[n]| ns], [[p]| ps], i, input, acc) do
    n1  = String.to_integer(n)
    pos = positions(p, i)
    adj = adjecent(pos)

    acc1 = Enum.reduce(adj, acc,
      fn(ij, acc) ->
        Map.update(acc, ij, [n1], fn(ns) -> [n1| ns] end)
      end)

    xxx(ns, ps, i, input, acc1)
  end

  def positions({f, l}, i) do
    f..f+(l-1)
    |> Enum.reduce(
      [],
      fn(j, acc) ->
        [{i, j}| acc]
      end
    )
    |> Enum.reverse
  end

  def adjecent([{i, j}| _] = ps) do
    adjecent(ps, [{i - 1, j - 1}, {i, j - 1}, {i + 1, j - 1}])
  end

  def adjecent([{i, j}], acc) do
    [{i - 1, j + 1}, {i, j + 1}, {i + 1, j + 1}, {i + 1, j}, {i - 1, j}| acc]
    |> Enum.reverse
  end
  def adjecent([{i, j} | ps], acc) do
    adjecent(ps, [{i + 1, j}, {i - 1, j}| acc])
  end
end

alias AOC23.D03

input     = IO.stream(:stdio, :line)
result    = D03.run(input)

IO.puts(result)
