defmodule AOC23.D10 do
  def run(input) do
    {_lines, grid0, start} =
    input
    |> Enum.reduce({0, [], {0, 0}},
    fn
      (line, {i, grid, start}) ->
        {_, grid, start} =
        line
        |> String.trim
        |> String.split("", trim: true)
        |> Enum.reduce({0, grid, start},
        fn
          ("S", {j, xs, _start}) ->
            {j + 1, [{{i, j}, "S"}| xs], {i, j}}
          (x, {j, xs, start}) ->
            {j + 1, [{{i, j}, x}| xs], start}
        end)
        {i + 1, grid, start}
    end)

    grid = Map.new(grid0)

    shape = shape(grid, start)
    grid = %{grid | start => shape}

    loop = traverse(grid, start, nil, [], start)

    {is, js} = boundaries(loop)
    enclosed(is, js, loop, grid)
    |> Enum.count
  end

  def enclosed(is, js, loop0, grid) do
    loop = Map.new(Enum.map(loop0, &({&1, true})))

    hs0 =
    Enum.reduce(is, [],
      fn(i, acc) ->
        {ps, _crossed} =
          Enum.reduce(js, {acc, 0},
            fn(j, {acc, crossed}) ->
              case trail?(loop, {i, j}) do
                true ->
                  case grid[{i, j}] do
                    "|" ->
                      {acc, crossed + 1}
                    "-" ->
                      {acc, crossed}
                    "7" ->
                      {acc, crossed + 0.5}
                    "L" ->
                      {acc, crossed + 0.5}
                    "F" ->
                      {acc, crossed - 0.5}
                    "J" ->
                      {acc, crossed - 0.5}
                  end
                false ->
                  case rem(trunc(crossed), 2) == 0 do
                    true  -> {acc, crossed}
                    false -> {[{i, j}| acc], crossed}
                  end
              end
            end)
        ps
      end)

    vs0 =
    Enum.reduce(js, [],
      fn(j, acc) ->
        {ps, _crossed} =
          Enum.reduce(is, {acc, 0},
            fn(i, {acc, crossed}) ->
              case trail?(loop, {i, j}) do
                true ->
                  case grid[{i, j}] do
                    "|" ->
                      {acc, crossed}
                    "-" ->
                      {acc, crossed + 1}
                    "7" ->
                      {acc, crossed + 0.5}
                    "L" ->
                      {acc, crossed + 0.5}
                    "F" ->
                      {acc, crossed - 0.5}
                    "J" ->
                      {acc, crossed - 0.5}
                  end
                false ->
                  case rem(trunc(crossed), 2) == 0 do
                    true  -> {acc, crossed}
                    false -> {[{i, j}| acc], crossed}
                  end
              end
            end)
        ps
      end)

    hs = Map.new(Enum.map(hs0, &({&1, true})))
    vs = Map.new(Enum.map(vs0, &({&1, true})))

    keys = Map.keys(hs) ++ Map.keys(vs) |> Enum.uniq
    Enum.map(keys, fn(k) ->
      {k, Map.get(hs, k, false) and Map.get(vs, k, false)}
    end)
    |> Enum.filter(fn({_k, v}) -> v end)
  end

  def trail?(trail, p), do: Map.get(trail, p, false)

  def boundaries(xs) do
    min_i = Enum.map(xs, fn({i, _j}) -> i end) |> Enum.min
    max_i = Enum.map(xs, fn({i, _j}) -> i end) |> Enum.max
    min_j = Enum.map(xs, fn({_i, j}) -> j end) |> Enum.min
    max_j = Enum.map(xs, fn({_i, j}) -> j end) |> Enum.max

    {min_i .. max_i, min_j .. max_j}
  end

  def traverse(grid, from, change, trail, start) do
    [dir| _] = conns(grid[from]) -- [reverse(change)]
    next = move(dir, from)
    case next do
      ^start ->
        [from| trail]
      _ ->
        traverse(grid, next, dir, [from| trail], start)
    end
  end

  def shape(grid, p) do
    [:up, :down, :left, :right]
    |> Enum.filter(fn(dir) -> connected?(grid, p, dir) end)
    |> Enum.sort
    |> shape
  end

  def connected?(grid, p, dir) do
    n = move(dir, p)
    Enum.member?(conns(grid[n]), reverse(dir))
  end

  def shape([:down, :up]),    do: "|"
  def shape([:left, :right]), do: "-"
  def shape([:right, :up]),   do: "L"
  def shape([:left, :up]),    do: "J"
  def shape([:down, :left]),  do: "7"
  def shape([:down, :right]), do: "F"

  def reverse(nil),    do: nil
  def reverse(:up),    do: :down
  def reverse(:down),  do: :up
  def reverse(:left),  do: :right
  def reverse(:right), do: :left

  def conns("|"), do: [:up, :down]
  def conns("-"), do: [:left, :right]
  def conns("L"), do: [:up, :right]
  def conns("J"), do: [:up, :left]
  def conns("7"), do: [:left, :down]
  def conns("F"), do: [:down, :right]
  def conns("."), do: []
  def conns("S"), do: []
  def conns(nil), do: []

  # change(from, to)
  def change({i, _j}, {a, _b}) when i > a, do: :up    # eg. from {1, 1} to {0, 1}
  def change({i, _j}, {a, _b}) when i < a, do: :down  # eg. from {0, 1} to {1, 1}
  def change({_i, j}, {_a, b}) when j > b, do: :left  # eg. from {1, 1} to {1, 0}
  def change({_i, j}, {_a, b}) when j < b, do: :right # eg. from {1, 0} to {1, 1}

  def move(:up,    {i, j}), do: ({i - 1, j})
  def move(:down,  {i, j}), do: ({i + 1, j})
  def move(:left,  {i, j}), do: ({i, j - 1})
  def move(:right, {i, j}), do: ({i, j + 1})
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D10.run(input)

IO.puts(result)
