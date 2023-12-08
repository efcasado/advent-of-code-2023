defmodule AOC23.D08 do
  def run(input) do
    {map0, directions0} =
    input
    |> Enum.reduce({[], []},
    fn
      ("\n", acc) ->
        acc

      (<<node :: binary-3, " = (", left :: binary-3, ", ", right :: binary-3, ")", _ :: binary>>, {graph, directions}) ->
        {[{node, {left, right}}| graph], directions}

      (line, {map, _}) ->
        directions =
        line
        |> String.trim
        |> String.split("", trim: true)
        {map, directions}
    end)

    map = Map.new(map0)

    ps =
    Map.keys(map)
    |> Enum.filter(fn(<<_ :: 16, "A">>) -> true; (_) -> false end)

    Enum.map(ps, fn(p) -> find(map, p, directions0) end)
    |> Enum.reduce(1, &lcm/2)

  end

  def find(map, a, directions) do
    find(map, a, directions, [], 0)
  end

  def find(map, p, [], dirs2, steps), do: find(map, p, Enum.reverse(dirs2), [], steps)
  def find(_map, <<_ :: 16, "Z">>, _dirs1, _dirs2, steps), do: steps
  def find(map, p0, [d| ds], dirs2, steps) do
    p =
      case d do
        "L" -> {p, _} = map[p0]; p
        "R" -> {_, p} = map[p0]; p
      end
    find(map, p, ds, [d| dirs2], steps + 1)
  end

  def lcm(x, y), do: div(x * y, Integer.gcd(x, y))
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D08.run(input)

IO.puts(result)
