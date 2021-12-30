defmodule Prepaid do

  defstruct credits: 10, recharges: []
  @minute_price 1.45

  @doc """
  Make a call.
  """
  def make_call(number, date, duration) do
    subscriber = Subscriber.search_subscriber(number, :prepaid)
    cost = @minute_price * duration

    cond do
      cost <= 10 ->
        {:ok, "This call costed #{cost}"}
      true ->
        {:error, "You do not have enough credits to complete the call. Please recharge."}
    end
  end
end
