defmodule AOC23.D19 do
  def run(input) do
    {ws, ps} = parse(input)

    Enum.flat_map(ps, fn(p) -> process(ws, p, ws["in"]) end)
    |> Enum.map(fn(p) -> Enum.reduce(p, 0, fn({_k, v}, acc) -> acc + v end) end)
    |> Enum.sum
  end

  def process(_ws,  p, ["A"]), do: [p]
  def process(_ws, _p, ["R"]), do: [ ]
  def process( ws, p, [l]) do
    process(ws, p, ws[l])
  end
  def process(ws, p, [{k, c, v, "A"}| rs]) do
    case evaluate(p, {k, c, v}) do
      false -> process(ws, p, rs)
      true  -> [p]
    end
  end
  def process(ws, p, [{k, c, v, "R"}| rs]) do
    case evaluate(p, {k, c, v}) do
      false -> process(ws, p, rs)
      true  -> []
    end
  end
  def process(ws, p, [{k, c, v, l}| rs]) do
    case evaluate(p, {k, c, v}) do
      false -> process(ws, p, rs)
      true  -> process(ws, p, ws[l])
    end
  end

  def evaluate(p, {k, ">", v}),do: p[k] > v
  def evaluate(p, {k, "<", v}), do: p[k] < v
  
  def parse(input) do
    {_, ws, ps} =
    input
    |> Enum.reduce({:workflows, [], []},
    fn
      ("\n", {:workflows, ws, ps}) ->
        {:parts, ws, ps}
      (line, {:workflows, ws, ps}) ->
        [_, name] = Regex.run(~r/([a-z]+){.+}/, line)
        rs =
        Regex.scan(~r/([x,m,a,s]{1}[<,>][0-9]+:[A-z]+)|,([A-z]+)}/, String.trim(line))
        |> Enum.map(
          fn
            ([_, _, next]) ->
              next
            ([_, match]) ->
              [_, x, c, n, a] = Regex.run(~r/([x,m,a,s]{1})([>,<]{1})([0-9]+):([A-z]+)/, match)
              {x, c, String.to_integer(n), a}
            (_) -> nil
          end)
        
        {:workflows, [{name, rs}| ws], ps}
      (line, {:parts, ws, ps}) ->
        p =
        Regex.scan(~r/([x,m,a,s]{1}=[0-9]+)/, String.trim(line))
        |> Enum.map(fn([_, match]) ->
          [t, n] = String.split(match, "=", trim: true)
          {t, String.to_integer(n)}
        end)
        |> Map.new
        {:parts, ws, [p| ps]}
    end)
    {Map.new(ws), Enum.reverse(ps)}
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D19.run(input)

IO.puts(result)
