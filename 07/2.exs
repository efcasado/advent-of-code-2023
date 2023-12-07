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
    cards0 = String.split(str_cards, "", trim: true)
    {jokers, cards} = Enum.reduce(cards0, {0, []},
      fn
        ("J", {js, cs}) -> {js + 1, cs};
        (  c, {js, cs}) -> {js, [c| cs]}
      end
    )
    bid    = String.to_integer(str_bid)

    type =
      Enum.group_by(cards, &(&1))
      |> Enum.map(fn({_c, cs}) -> Enum.count(cs) end)
      |> Enum.sort(&(&1 > &2))
      |> type(jokers)

    weights = Enum.map(cards0, &weight/1)

    {str_cards, type, weights, bid}
  end

  def type(_         ,  5),                            do: 7 # five of a kind
  def type([c1| _]   ,  jokers) when c1 + jokers == 5, do: 7 # five of a kind
  def type([c1| _]   ,  jokers) when c1 + jokers == 4, do: 6 # four of a kind
  def type([c1, 2| _],  jokers) when c1 + jokers == 3, do: 5 # full house
  def type([c1| _]   ,  jokers) when c1 + jokers == 3, do: 4 # three of a kind
  def type([c1, 2| _],  jokers) when c1 + jokers == 2, do: 3 # two pair
  def type([c1| _]   ,  jokers) when c1 + jokers == 2, do: 2 # one pair
  def type(_         , _jokers),                       do: 1 # high card

  def weight("A"), do: 13
  def weight("K"), do: 12
  def weight("Q"), do: 11
  def weight("T"), do: 10
  def weight("9"), do:  9
  def weight("8"), do:  8
  def weight("7"), do:  7
  def weight("6"), do:  6
  def weight("5"), do:  5
  def weight("4"), do:  4
  def weight("3"), do:  3
  def weight("2"), do:  2
  def weight("J"), do:  1
end


input     = IO.stream(:stdio, :line)
result    = AOC23.D07.run(input)

IO.puts(result)
