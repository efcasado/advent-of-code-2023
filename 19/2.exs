defmodule AOC23.D19 do
  @ps ["a", "m", "s", "x"]

  def run(input) do
    {ws, _ps} = parse(input)
    p = Map.new(Enum.map(@ps, &({&1, {1, 4_000}})))
    process(ws, p, ws["in"])
  end

  def process(_ws,  p, ["A"]), do: combis(p)
  def process(_ws, _p, ["R"]), do: 0
  def process( ws,  p, [ l ]), do: process(ws, p, ws[l])
  def process(ws, p, [{k, c, v, "A"}| rs]) do
    process(ws, adjust(p, k, c, v, true), rs) + combis(adjust(p, k, c, v))
  end
  def process(ws, p, [{k, c, v, "R"}| rs]) do
    process(ws, adjust(p, k, c, v, true), rs)
  end
  def process(ws, p, [{k, c, v, l}| rs]) do
    process(ws, adjust(p, k, c, v, true), rs) + process(ws, adjust(p, k, c, v), ws[l])
  end

  def combis(p), do: Enum.reduce(@ps, 1, fn(e, acc) -> values(p[e]) * acc end)

  def values({f, t}), do: t - f + 1

  # Eg.
  # x={1, 10} x<7:A => {1,  6}
  # x={1, 10} x>7:A => {8, 10}
  #
  # x={1, 10} x<7:R => {7, 10}
  # x={1, 10} x>7:R => {1,  7}
  def adjust(p, k, c, v, flip \\ false)
  def adjust(p, k, "<", v, false) do
    {f, t} = p[k]
    %{p| k => {f, min(t, v - 1)}}
  end
  def adjust(p, k, ">", v, false) do
    {f, t} = p[k]
    %{p| k => {max(f, v + 1), t}}
  end
  def adjust(p, k, "<", v, true) do
    {f, t} = p[k]
    %{p| k => {max(f, v), t}}
  end
  def adjust(p, k, ">", v, true) do
    {f, t} = p[k]
    %{p| k => {f, min(t, v)}}
  end

  def evaluate(p, {k, ">", v}), do: p[k] > v
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
