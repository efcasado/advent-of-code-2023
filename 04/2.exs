defmodule AOC23.D04 do
  def run(input) do
    {lines, cards} =
    input
    |> Enum.reduce({1, %{}}, fn(line, {l, cards0}) ->
      cards1 = Map.update(cards0, l, 1, fn(n) -> n + 1 end)
      ncards = Map.get(cards1, l, 0)
      {cnums, wnums} = numbers_from_line(line)
      nwnums = n_wining_numbers(cnums, wnums)

      cards2 =
        case nwnums do
          0 -> cards1
          _ ->
            cards_won = ((l + 1)..(l + 1 + nwnums - 1))
            Enum.reduce(cards_won, cards1, fn(c, acc) ->
              Map.update(acc, c, ncards, fn(n0) -> n0 + ncards end)
            end)
        end

      {l + 1, cards2}
    end)

    cards
    |> Enum.filter(fn({k, _v}) -> k <= lines end)
    |> Enum.reduce(0, fn({_c, n}, acc) -> acc + n end)
  end

  def numbers_from_line(line0) do
    line1 = String.trim(line0)
      [_card_num, line2] = String.split(line1, ":")
      [card, winnings] = String.split(line2, " | ", trim: true)
      cnums = String.split(card, " ", trim: true)
      wnums = String.split(winnings, " ", trim: true)
      {cnums, wnums}
  end

  def n_wining_numbers(cnums, wnums0) do
    wnums1 = MapSet.new(wnums0)
    Enum.reduce(cnums, 0, fn(n, acc) ->
      case MapSet.member?(wnums1, n) do
        true  -> acc + 1
        false -> acc
      end
    end)
  end
end

alias AOC23.D04

input     = IO.stream(:stdio, :line)
result    = D04.run(input)

IO.puts(result)
