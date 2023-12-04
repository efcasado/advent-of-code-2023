defmodule AOC23.D04 do
  def run(input) do
    Enum.reduce(input, 0, fn(line0, acc) ->
      {cnums, wnums} = numbers_from_line(line0)
      wnums = MapSet.new(wnums)
      ws = Enum.reduce(cnums, 0, fn(n, acc) ->
        case MapSet.member?(wnums, n) do
          true  -> acc + 1
          false -> acc
        end
      end)
      case ws do
        0 -> acc
        _ -> acc + 2 ** (ws - 1)
      end
    end)
  end

  def numbers_from_line(line0) do
    line1 = String.trim(line0)
      [_card_num, line2] = String.split(line1, ":")
      [card, winnings] = String.split(line2, " | ", trim: true)
      cnums = String.split(card, " ", trim: true)
      wnums = String.split(winnings, " ", trim: true)
      {cnums, wnums}
  end
end

alias AOC23.D04

input     = IO.stream(:stdio, :line)
result    = D04.run(input)

IO.puts(result)
