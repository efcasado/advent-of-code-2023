defmodule AOC23.D05 do
  def run(input) do
    {seeds, s2s, s2f, f2w, w2l, l2t, t2h, h2l} = parse(input)

    {from, _to} =
    seeds
    |> Enum.reduce([], fn(x, acc) -> acc ++ location(x, [s2s, s2f, f2w, w2l, l2t, t2h, h2l]) end)
    |> Enum.min

    from
  end

  def parse(input0) do
    [h2l, t2h, l2t, w2l, f2w, s2f, s2s, seeds] =
      Enum.reduce(input0, [],
        fn
          ("\n", acc) ->
            acc
          (<<"seeds: ", str_seeds :: binary>>, acc) ->
            seeds =
            integers_from_line(str_seeds)
            |> Enum.chunk_every(2)
            |> Enum.map(fn([from, step]) -> [{from, from + step - 1}] end)
            [seeds| acc]
          (<<"seed-to-soil", _ :: binary>>, acc) ->
            [[]| acc]
          (<<"soil-to-fertilizer", _ :: binary>>, acc) ->
            [[]| acc]
          (<<"fertilizer-to-water", _ :: binary>>, acc) ->
            [[]| acc]
          (<<"water-to-light", _ :: binary>>, acc) ->
            [[]| acc]
          (<<"light-to-temperature", _ :: binary>>, acc) ->
            [[]| acc]
          (<<"temperature-to-humidity", _ :: binary>>, acc) ->
            [[]| acc]
          (<<"humidity-to-location", _ :: binary>>, acc) ->
            [[]| acc]
          (line, [x| xs]) ->
            [d0, s0, step] = integers_from_line(line)
            [[{s0, s0 + step - 1, d0}| x]| xs]
        end)

    {seeds, s2s, s2f, f2w, w2l, l2t, t2h, h2l}
  end

  def integers_from_line(line) do
    line
    |> String.trim
    |> String.split(" ")
    |> Enum.map(&(String.to_integer(&1)))
  end

  def location(seed, maps) do
    Enum.reduce(maps, seed,
      fn(map, range) ->
        routes2(map, range, [])
      end)
  end

  def routes2(_map, [], acc) do
    acc
  end
  def routes2(map, [r| rs], acc) do
    routes2(map, rs, acc ++ routes(map, [r], []))
  end

  def xxx2(r1s, [], {bk, fw}) do
    r1s ++ bk ++ fw
  end
  def xxx2([], [_| r2s], {bk, fw}) do
    xxx2(bk, r2s, {[], fw})
  end
  def xxx2([r1| r1s], [r2| _] = r2ss, {bk0, fw0}) do
    {fw, bk} = yyy(r1, r2)
    xxx2(r1s, r2ss, {bk0 ++ bk, fw0 ++ fw})
  end

  def yyy({from0, to0}, {from1, to1, target})
  when from0 >= from1 and to0 <= to1 do
    push  = [{target + (from0 - from1), target + (from0 - from1) + (to0 - from0)}]
    retry = []
    {push, retry}
  end
  def yyy({from0, to0}, {from1, to1, target})
  when from1 > from0 and to1 < to0 do
    push  = [{target, target + (to1 - from1)}]
    retry = [{from0, from1 - 1}, {to1 + 1, to0}]
    {push, retry}
  end
  def yyy({from0, to0}, {from1, to1, target})
  when from0 >= from1 and from0 <= to1 do
    push  = [{target + (from0 - from1), target + (from0 - from1) + Enum.min([(to0 - from0), (to1 - from0)])}]
    retry = [{to1 + 1, to0}]
    {push, retry}
  end
  def yyy({from0, to0}, {from1, to1, target})
  when to0 >= from1 and to0 <= to1 do
    push  = [{target, target + (to0 - from1)}]
    retry = [{from0, from1 - 1}]
    {push, retry}
  end
  def yyy(r0, _r1) do
    push  = []
    retry = [r0]
    {push, retry}
  end

  def routes(_map, [], acc) do
    acc
  end
  def routes(map, [_| xs] = xss, acc) do
    fw = xxx2(xss, map, {[], []})
    routes(map, [] ++ xs, fw ++ acc)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D05.run(input)

IO.puts(result)
