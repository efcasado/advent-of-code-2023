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

    traverse(grid, start, nil, [], start)
    |> Enum.count
    |> Kernel.div(2)
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
