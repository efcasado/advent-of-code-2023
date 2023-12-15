defmodule AOC23.D15 do
  def run(input) do
    input
    |> Enum.reduce(0,
    fn(line, _acc) ->
      line
      |> String.trim
      |> String.split(",", trim: true)
      #|> IO.inspect
      |> Enum.reduce(%{},
      fn(step, m) ->
        {l, o, fl} = lofl(step)
        box = hash(l, 0)
        process(box, l, fl, o, m)
      end)
      #|> IO.inspect
      |> Enum.reduce(0,
      fn({box, ls}, acc) ->
        acc + power(box, ls, 1, 0)
      end)
    end)
  end

  def power(_, [], _, acc) do
    acc
  end
  def power(box, [{_, fl}| ls], step, acc) do
    power(box, ls, step + 1, acc + (box + 1) * step * String.to_integer(fl))
  end

  def process(box, l, fl, "=", m) do
    update(m, box, l, fl)
  end
  def process(box, l, _fl, "-", m) do
    delete(m, box, l)
  end

  def update(m, k, x, y) do
    Map.update(m, k, [{x, y}], fn(es0) -> replace(es0, {x, y}) end)
  end

  def replace(es, e, acc \\ [])
  def replace([], e, acc) do
    Enum.reverse([e| acc])
  end
  def replace([{x, _y0}| xs], {x, y1}, acc) do
    Enum.reverse([{x, y1}| acc]) ++ xs
  end
  def replace([x| xs], e, acc) do
    replace(xs, e, [x| acc])
  end

  def delete(m, k, x) do
    es =
    Map.get(m, k, [])
    |> Enum.filter(fn({x0, _y}) -> x != x0 end)

    Map.put(m, k, es)
  end

  def lofl(step) do
    [[_, l, o, fl]] = Regex.scan(~r/^([^=|-]+)(=|-){1}(.*)$/, step)
    {l, o, fl}
  end

  def hash(<<>>, cv), do: cv
  def hash(<<x, xs :: binary>>, cv) do
    hash(xs, rem((cv + x) * 17, 256))
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D15.run(input)

IO.puts(result)
