defmodule AOC23.D14 do
  def run(input) do
    parse(input)
    #|> IO.inspect
    |> Enum.map(&(load(&1, Enum.count(&1), [{Enum.count(&1), 0}])))
    |> Enum.sum
  end

  def load([], _p, acc) do
    acc
    #|> IO.inspect
    |> Enum.filter(fn({_, n}) -> n > 0 end)
    #|> IO.inspect
    |> Enum.map(fn({from, n}) -> Enum.sum(from..(from-(n-1))) end)
    #|> IO.inspect
    |> Enum.sum
  end
  def load(["O"| xs], p, [{s, n} |as]) do
    load(xs, p - 1, [{s, n + 1}| as])
  end
  def load(["#"| xs], p, acc) do
    load(xs, p - 1, [{p - 1, 0}| acc])
  end
  def load(["."| xs], p, acc) do
    load(xs, p - 1, acc)
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
      # prepare for tilting north
      |> rotate
  end

  def rotate([[] | _]), do: []
  def rotate(m),        do: [Enum.map(m, &hd/1) | rotate(Enum.map(m, &tl/1))]
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D14.run(input)

IO.puts(result)
