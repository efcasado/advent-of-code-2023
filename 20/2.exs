defmodule AOC23.D20 do
  @is ["kl", "vm", "kv", "vb"]

  def run(input) do
    ms = parse(input)

    # kl -> ll
    # vm -> ll
    # kv -> ll
    # vb -> ll
    #
    # ll -> rx
    cycles(ms, 1, Map.new(Enum.map(@is, &({&1, 0}))), [])
    # |> IO.inspect
    |> Enum.reduce(1, &lcm/2)
  end

  def lcm(x, y), do: div(x * y, Integer.gcd(x, y))

  def cycles(_ms, _n, _acc, [_, _, _, _] = cs), do: cs
  def cycles(ms0,  n, acc0, cs) do
    {ms1, acc1} = cycle(ms0, [{"button", "broadcaster", :l}], acc0)
    case acc0 != acc1 do
      true  -> cycles(ms1, n + 1, acc1, [n| cs])
      false -> cycles(ms1, n + 1, acc1, cs)
    end
  end
  
  def cycle(ms, [], acc) do
    {ms, acc}
  end
  def cycle(ms0, [{from, to, p0}| ps], acc) do
    case ms0[to] do
      nil ->
        cycle(ms0, ps, acc)
      {t, s0, os} ->
        {s1, p1} = process(t, s0, {from, p0})
        ms1 = %{ms0| to => {t, s1, os}}
        next = Enum.map(os, &({to, &1, p1}))
        case p1 do
          nil -> cycle(ms1, ps, update({from, to, p0}, acc))
          _   -> cycle(ms1, ps ++ next, update({from, to, p0}, acc))
        end
    end
  end

  def update({from, "ll", :h}, acc), do: %{acc| from => acc[from] + 1}
  def update(               _, acc), do: acc
  
  def process(:b, state,       _), do: {state,  :l}
  def process(:f, state, {_, :h}), do: {state, nil}
  def process(:f,   :on, {_, :l}), do: { :off,  :l}
  def process(:f,  :off, {_, :l}), do: {  :on,  :h}
  def process(:c, state0, {f,  p}) do
    state = %{state0| f => p}
    case Enum.all?(state, fn({_, p}) -> p == :h end) do
      true  ->
        {state, :l}
      false ->
        {state, :h}
    end
  end
  
  def parse(input) do
    ms0 =
    input
    |> Enum.map(fn(line) ->
      [from, to] = line
      |> String.trim
      |> String.split(" -> ")

      to = String.split(to, ", ")
      {t, n, s} = tns(from)
      {n,  {t, s, to}}
    end)

    ms1 = Map.new(ms0)
    
    cjs = Enum.filter(ms1, fn({_, {t, _, _}}) -> t == :c end) |> Enum.map(fn({n, _}) -> n end)

    csis = Enum.map(cjs, fn(c) ->
      is =
      Enum.filter(ms1, fn({_, {_, _, to}}) ->
        Enum.member?(to, c)
      end)
      |> Enum.map(fn({n, _}) -> n end)
      {c, is}
    end)

    ms2 = Enum.reduce(csis, ms1, fn({k, is}, ms) ->
      {t, _, to} = ms[k]
      %{ms| k => {t, Map.new(is, &({&1, :l})), to}}
    end)
    
    ms2
  end

  def tns("broadcaster" = n),    do: {:b, n,  nil}
  def tns(<<"%", n :: binary>>), do: {:f, n, :off}
  def tns(<<"&", n :: binary>>), do: {:c, n,  nil}
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D20.run(input)

IO.puts(result)
