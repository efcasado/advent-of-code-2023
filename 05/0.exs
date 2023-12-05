defmodule AOC23.D05 do
  def run(input) do
    {seeds, s2s, s2f, f2w, w2l, l2t, t2h, h2l} = parse(input)

    seeds
    |> Enum.map(&(location(&1, [s2s, s2f, f2w, w2l, l2t, t2h, h2l])))
    |> Enum.min
  end

  def parse(input0) do
    [h2l, t2h, l2t, w2l, f2w, s2f, s2s, seeds] =
      Enum.reduce(input0, [],
        fn
          ("\n", acc) ->
            acc
          (<<"seeds: ", str_seeds :: binary>>, acc) ->
            seeds = integers_from_line(str_seeds)
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
            routes = Enum.zip(s0 .. (s0 + step - 1), d0 .. (d0 + step - 1))
            [routes ++ x| xs]
        end)

    {seeds, Map.new(s2s), Map.new(s2f), Map.new(f2w), Map.new(w2l), Map.new(l2t), Map.new(t2h), Map.new(h2l)}
  end

  def integers_from_line(line) do
    line
    |> String.trim
    |> String.split(" ")
    |> Enum.map(&(String.to_integer(&1)))
  end

  def location(seed, maps) do
    Enum.reduce(maps, seed, &(Map.get(&1, &2, &2)))
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D05.run(input)

IO.puts(result)
