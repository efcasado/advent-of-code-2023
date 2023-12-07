defmodule AOC23.D07 do
  def run(input) do
    input
    |> Enum.map(&parse_line/1)
    |> rank
    |> Enum.reduce(0, fn({{_, _, _, bid}, rank}, acc) -> rank * bid + acc end)
  end

  def rank(hands) do
    hands
    |> Enum.sort(
    fn
      ({_, t, w1, _}, {_, t, w2, _}) -> w1 < w2;
      ({_, t1, _, _}, {_, t2, _, _}) -> t1 < t2
    end)
    |> Enum.zip(1 .. Enum.count(hands))
  end

  def parse_line(line) do
    [str_cards, str_bid] =
      line
      |> String.trim
      |> String.split(" ")
    cards = String.split(str_cards, "", trim: true)
    bid   = String.to_integer(str_bid)

    type =
      Enum.group_by(cards, &(&1))
      |> Enum.map(fn({_c, cs}) -> Enum.count(cs) end)
      |> Enum.sort(&(&1 > &2))
      |> type

    weights = Enum.map(cards, &weight/1)

    {str_cards, type, weights, bid}
  end

  def type([5]),       do: 7 # five of a kind
  def type([4| _]),    do: 6 # four of a kind
  def type([3, 2| _]), do: 5 # full house
  def type([3| _]),    do: 4 # three of a kind
  def type([2, 2| _]), do: 3 # two pair
  def type([2| _]),    do: 2 # one pair
  def type(_),         do: 1 # high card

  def weight("A"), do: 13
  def weight("K"), do: 12
  def weight("Q"), do: 11
  def weight("J"), do: 10
  def weight("T"), do:  9
  def weight("9"), do:  8
  def weight("8"), do:  7
  def weight("7"), do:  6
  def weight("6"), do:  5
  def weight("5"), do:  4
  def weight("4"), do:  3
  def weight("3"), do:  2
  def weight("2"), do:  1
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D07.run(input)

IO.puts(result)
