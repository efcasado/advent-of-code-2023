defmodule AOC23.D02 do
  def run(input, constrain) do
    input
    |> Enum.map(fn(line) -> parse(line) end)
    |> Enum.reduce(0,
    fn({id, _rounds} = game, acc) ->
      case valid_game?(game, constrain) do
        true ->
          acc + id
        false ->
          acc
      end
    end)
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

  def valid_game?({_id, rounds} = _game, constrain) do
    valid?(rounds, constrain)
  end

  def valid?([], _constrain) do
    true
  end
  def valid?([r| rs], constrain) do
    case Enum.all?(r, fn({c, n}) -> constrain[c] >= n end) do
      true  -> valid?(rs, constrain)
      false -> false
    end
  end
end

alias AOC23.D02

input     = IO.stream(:stdio, :line)
constrain = %{"red" => 12, "green" => 13, "blue" => 14}
result    = D02.run(input, constrain)

IO.puts(result)
