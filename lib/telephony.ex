defmodule Telephony do

  @doc """
  Start default telephony settings.
  """
  def start do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))
  end

  @doc """
  Create telephony subscriber given a plan type `prepaid` or `postpaid`.

  No type given will create `prepaid` subscriber by default.

  ## Params

  - name: subscriber name
  - number: unique number which can return an error
  - itin: subscriber's identification number
  - plan: plan type `prepaid` or `postpaid`

  ## Additional info

  - In case the number already exists an error message will be returned.

  ## Example

      iex> Telephony.start()
      iex> Telephony.create_subscriber("Rick", "123", "123", :prepaid)
      {:ok, "Hello Rick, your subscription was created successfully!"}
  """
  def create_subscriber(name, number, itin, plan) do
    Subscriber.create(name, number, itin, plan)
  end

  @doc """
  List all subscribers
  """
  def list_subscribers, do: Subscriber.subscribers()

  @doc """
  List all prepaid subscribers
  """
  def list_prepaid_subscribers, do: Subscriber.prepaid_subscribers()

  @doc """
  List all postpaid subscribers
  """
  def list_postpaid_subscribers, do: Subscriber.postpaid_subscribers()

  @doc """
  Performs a call
  """
  def make_call(number, plan, date, duration) do
    cond do
      plan == :prepaid -> Prepaid.make_call(number, date, duration)
      plan == :postpaid -> Postpaid.make_call(number, date, duration)
    end
  end

  @doc """
  Performs a recharge
  """
  def recharge(number, date, value), do: Recharge.new(date, value, number)

  @doc """
  Search subscriber by number
  """
  def search_by_number(number, plan \\ :all), do: Subscriber.search_subscriber(number, plan)

  @doc """
  Prints the data of all bills
  """
  def print_bills(month, year) do
    Subscriber.prepaid_subscribers()
    |> Enum.each(fn subscriber ->
      subscriber = Prepaid.print_bill(month, year, subscriber.number)
      IO.puts("Prepaid subscriber bill: #{subscriber.name}")
      IO.puts("Prepaid subscriber number: #{subscriber.number}")
      IO.puts("Prepaid subscriber number: #{subscriber.number}")
      IO.puts("Calls: ")
      IO.inspect(subscriber.calls)
      IO.puts("Recharges: ")
      IO.inspect(subscriber.plan.recharges)
      IO.puts("Calls Total: #{Enum.count(subscriber.calls)}")
      IO.puts("Rechages Total: #{Enum.count(subscriber.plan.recharges)}")
      IO.puts("_____________________________________________________________")
    end)

    Subscriber.postpaid_subscribers()
    |> Enum.each(fn subscriber ->
      subscriber = Postpaid.print_bill(month, year, subscriber.number)
      IO.puts("Postpaid subscriber bill: #{subscriber.name}")
      IO.puts("Postpaid subscriber number: #{subscriber.number}")
      IO.puts("Postpaid subscriber number: #{subscriber.number}")
      IO.puts("Calls: ")
      IO.inspect(subscriber.calls)
      IO.puts("Calls Total: #{Enum.count(subscriber.calls)}")
      IO.puts("Invoice Total: #{subscriber.plan.value}")
      IO.puts("_____________________________________________________________")
    end)
  end
end
