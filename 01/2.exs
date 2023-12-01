defmodule AOC23.D02 do
  def run(input) do
    Enum.reduce(input, 0, fn line, acc -> calibration_value(line) + acc end)
  end

  def calibration_value(line) do
    [_, d1] =
      Regex.run(
        ~r/[^0-9|one|two|three|four|five|six|seven|eight|nine]*([0-9]{1}|one|two|three|four|five|six|seven|eight|nine).*$/,
        line
      )

    [_, d2] =
      Regex.run(
        ~r/.*([0-9]{1}|one|two|three|four|five|six|seven|eight|nine)[^0-9]*|(!?one|two|three|four|five|six|seven|eight|nine)*$/,
        line
      )

    str_value = digit(d1) <> digit(d2)
    String.to_integer(str_value)
  end

  def digit("one"),   do: "1"
  def digit("two"),   do: "2"
  def digit("three"), do: "3"
  def digit("four"),  do: "4"
  def digit("five"),  do: "5"
  def digit("six"),   do: "6"
  def digit("seven"), do: "7"
  def digit("eight"), do: "8"
  def digit("nine"),  do: "9"
  def digit(digit),   do: digit
end

alias AOC23.D02

input = IO.stream(:stdio, :line)

result = D02.run(input)
IO.puts(result)
