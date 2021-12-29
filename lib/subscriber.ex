defmodule Subscriber do
  @moduledoc """
    Subscriber module for subscriptions of types `prepaid` and `postpaid`.

    The most used function is `create/4`
  """

  defstruct name: nil, number: nil, itin: nil, plan: nil

  @subscribers %{:prepaid => "pre.txt", :postpaid => "post.txt"}

  @doc """
  Get all prepaid subscribers.

  ## Example

      iex> Subscriber.create("Rick", "123", "123")
      iex> Subscriber.create("Ana", "1234", "1234")
      iex> Subscriber.prepaid_subscribers
      [
        %Subscriber{itin: "123", name: "Rick", number: "123", plan: :prepaid},
        %Subscriber{itin: "1234", name: "Ana", number: "1234", plan: :prepaid}
      ]
  """
  def prepaid_subscribers, do: read(:prepaid)

  @doc """
  Get all postpaid subscribers.

  ## Example

      iex> Subscriber.create("Rick", "123", "123", :postpaid)
      iex> Subscriber.create("Ana", "1234", "1234", :postpaid)
      iex> Subscriber.postpaid_subscribers
      [
        %Subscriber{itin: "123", name: "Rick", number: "123", plan: :postpaid},
        %Subscriber{itin: "1234", name: "Ana", number: "1234", plan: :postpaid}
      ]
  """
  def postpaid_subscribers, do: read(:postpaid)

  @doc """
  Get all subscribers.

  ## Example

      iex> Subscriber.create("Rick", "123", "123")
      iex> Subscriber.create("Ana", "1234", "1234", :postpaid)
      iex> Subscriber.subscribers
      [
        %Subscriber{itin: "123", name: "Rick", number: "123", plan: :prepaid},
        %Subscriber{itin: "1234", name: "Ana", number: "1234", plan: :postpaid}
      ]
  """
  def subscribers, do: read(:prepaid) ++ read(:postpaid)

  @doc """
  Search subscriber undependent of its plan when no plan type given.

  ## Params

  - number: unique subscriber number
  - plan: optional plan type

  ## Example

      iex> Subscriber.create("Rick", "123", "123")
      iex> Subscriber.search_subscriber("123")
      %Subscriber{itin: "123", name: "Rick", number: "123", plan: :prepaid}
  """
  def search_subscriber(number, plan \\ :all), do: search(number, plan)
  defp search(number, :prepaid), do: filter(prepaid_subscribers(), number)
  defp search(number, :postpaid), do: filter(postpaid_subscribers(), number)
  defp search(number, :all), do: filter(subscribers(), number)

  defp filter(list, number), do: Enum.find(list, &(&1.number == number))

  @doc """
  Create subscriber given a plan type `prepaid` or `postpaid`.

  No type given will create `prepaid` subscriber by default.

  ## Params

  - name: subscriber name
  - number: unique number which can return an error
  - itin: subscriber's identification number
  - plan: optional which in case of not informed will be created with `prepaid` plan

  ## Additional info

  - In case the number already exists an error message will be returned.

  ## Example

      iex> Subscriber.create("Rick", "123", "123")
      {:ok, "Hello Rick, your subscription was created successfully!"}
  """
  def create(name, number, itin, plan \\ :prepaid) do
    case search_subscriber(number) do
      nil ->
        (read(plan) ++ [%__MODULE__{name: name, number: number, itin: itin, plan: plan}])
          |> :erlang.term_to_binary()
          |> write(plan)

          {:ok, "Hello #{name}, your subscription was created successfully!"}
      _subscriber ->
        {:error, "Subscriber with this number already exists!"}
    end
  end

  defp write(subscribers, plan) do
    File.write!(@subscribers[plan], subscribers)
  end

  @doc """
  Read subscribers data file.

  ## Params

  - plan: plan type so the function knows which file to read `"pre.txt"` or `"post.txt"`.
  """
  def read(plan) do
    case File.read(@subscribers[plan]) do
      {:ok, subscribers} ->
        subscribers
        |> :erlang.binary_to_term()
      {:error, :enoent} -> {:error, "Invalid File."}
    end
  end
end