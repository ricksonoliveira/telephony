defmodule Bills do

  def print(month, year, number, plan) do
    subscriber = Subscriber.search_subscriber(number)
    calls_of_the_month = get_element_of_the_month(subscriber.calls, month, year)

    cond do
      plan == :prepaid ->
        recharges_of_the_month = get_element_of_the_month(subscriber.plan.recharges, month, year)
        plan = %Prepaid{subscriber.plan | recharges: recharges_of_the_month}
        %Subscriber{subscriber | calls: calls_of_the_month, plan: plan}
      plan == :postpaid ->
        %Subscriber{subscriber | calls: calls_of_the_month}
    end
  end

  def get_element_of_the_month(elments, month, year) do
    elments
    |> Enum.filter(&(&1.date.year == year and &1.date.month == month))
  end
end
