defmodule AOC23.D02 do
  def run(input) do
    input
    |> Enum.map(fn(line) -> parse(line) end)
    |> Enum.reduce(0, fn({_id, rounds} = _game, acc) -> power(rounds) + acc end)
  end

  def parse(line0) do
    line = String.trim(line0) # remove trailing "\n"
    [str_id, str_rounds] = String.split(line, ":")
    {id(str_id), rounds(str_rounds)}
  end

  def id(str_id) do
    [_, id] = String.split(str_id, " ")
    String.to_integer(id)
  end

  def rounds(str_rounds) do
    # " 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    String.split(str_rounds, ";")
    |> Enum.map(fn(str_round) ->
      # " 3 blue, 4 red"
      String.split(str_round, ",")
      |> Enum.map(fn(str_balls) ->
        # " 3 blue"
        [number, color] = String.split(str_balls, " ", trim: true)
        {color, String.to_integer(number)}
      end)
    end)
  end

  def power(rounds) do
    required(rounds, %{})
    |> Enum.reduce(1, fn({_color, number}, acc) -> acc * number end)
  end

  def required([], max) do
    max
  end
  def required([r| rs], max0) do
    max1 = Enum.reduce(r, max0,
      fn({c, n}, acc) ->
        Map.update(acc, c, n,
          fn(n0) when n > n0 ->
              n
            (n0)->
              n0
          end)
      end)
    required(rs, max1)
  end
end

alias AOC23.D02

input     = IO.stream(:stdio, :line)
result    = D02.run(input)

IO.puts(result)
