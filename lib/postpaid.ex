defmodule Postpaid do
  defstruct value: 0

  @minute_price 1.40

  def make_call(number, date, duration) do
    Subscriber.search_subscriber(number, :postpaid)
    |> Call.register(date, duration)

    {:ok, "Call was successfull! Duration: #{duration} minutes."}
  end

  def print_bill(month, year, number) do
    subscriber = Bills.print(month, year, number, :postpaid)

    total = subscriber.calls
    |> Enum.map(&(&1.duration * @minute_price))
    |> Enum.sum()

    %Subscriber{subscriber | plan: %__MODULE__{value: total}}
  end
end
