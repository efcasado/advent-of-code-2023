defmodule AOC23.D08 do
  def run(input) do
    {map0, directions0} =
    input
    |> Enum.reduce({[], []},
    fn
      ("\n", acc) ->
        acc

      (<<_ :: 24, " = ", _ :: binary>> = line, {map, directions}) ->
        [[node, _], [left, _], [right, _]] = Regex.scan(~r/([A-Z]{3})/, line)
        {[{node, {left, right}}| map], directions}

      (line, {map, _}) ->
        directions =
        line
        |> String.trim
        |> String.split("", trim: true)
        {map, directions}
    end)

    map = Map.new(map0)

    find(map, "AAA", "ZZZ", directions0)
  end

  def find(map, a, z, directions) do
    find(map, a, z, directions, [], 0)
  end

  def find(map, a, z, [], dirs2, steps), do: find(map, a, z, Enum.reverse(dirs2), [], steps)
  def find(_map, a, a, _dirs1 , _dirs2, steps), do: steps
  def find(map, a0, z, [d| ds], dirs2, steps) do
    a =
      case d do
        "L" -> {a, _} = map[a0]; a
        "R" -> {_, a} = map[a0]; a
      end
    find(map, a, z, ds, [d| dirs2], steps + 1)
  end
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D08.run(input)

IO.puts(result)
