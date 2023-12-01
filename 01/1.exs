defmodule AOC23.D01 do
  def run(input) do
    Enum.reduce(input, 0, fn line, acc -> calibration_value(line) + acc end)
  end

  def calibration_value(line) do
    [_, d1] = Regex.run(~r/[^0-9]*([0-9]{1}).*$/, line)
    [_, d2] = Regex.run(~r/.*([0-9]{1})[^0-9]*$/, line)
    str_value = d1 <> d2
    String.to_integer(str_value)
  end
end

alias AOC23.D01

input = IO.stream(:stdio, :line)

result = D01.run(input)
IO.puts(result)
