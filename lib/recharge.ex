defmodule Recharge do
  defstruct date: nil, value: nil

  def new(date, value, number) do
    subscriber = Subscriber.search_subscriber(number, :prepaid)
    plan = subscriber.plan

    plan = %Prepaid{
      plan
      | credits: plan.credits + value,
        recharges: plan.recharges ++ [%__MODULE__{date: date, value: value}]
    }

    subscriber = %Subscriber{subscriber | plan: plan}
    Subscriber.update(number, subscriber)
    {:ok, "Recharged Successfully!"}
  end
end
