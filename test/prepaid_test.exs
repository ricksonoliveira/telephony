defmodule PrepaidTest do
  use ExUnit.Case
  doctest Prepaid

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "Functions of Calls" do
    test "Make a call" do
      Subscriber.create("Rick", "123", "123", :prepaid)
      Recharge.new(DateTime.utc_now(), 10, "123")

      assert Prepaid.make_call("123", DateTime.utc_now(), 3) ==
        {:ok, "This call costed 4.35, you have 5.65 credits."}
    end

    test "Make a long call that will spend all credits" do
      Subscriber.create("Rick", "123", "123", :prepaid)

      assert Prepaid.make_call("123", DateTime.utc_now(), 10) ==
        {:error, "You do not have enough credits to complete the call. Please recharge."}
    end
  end

  describe "Tests to print bills" do
    test "should inform values for the bill of the month" do
      Subscriber.create("Rick", "123", "123", :prepaid)
      date = DateTime.utc_now()
      old_date = ~U[2021-12-03 19:15:03.283786Z]
      Recharge.new(date, 10, "123")
      Prepaid.make_call("123", date, 3)
      Recharge.new(old_date, 10, "123")
      Prepaid.make_call("123", old_date, 3)

      subscriber = Subscriber.search_subscriber("123", :prepaid)
      assert Enum.count(subscriber.calls) == 2
      assert Enum.count(subscriber.plan.recharges) == 2

      subscriber = Prepaid.print_bill(date.month, date.year, "123")

      assert subscriber.number == "123"
      assert Enum.count(subscriber.calls) == 1
      assert Enum.count(subscriber.plan.recharges) == 1
    end
  end
end
