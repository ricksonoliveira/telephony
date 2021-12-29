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
  - plan: optional which in case of not informed will be created with `prepaid` plan

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
end
