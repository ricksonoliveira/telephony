defmodule PostpaidTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  test "should make a call" do
    Subscriber.create("Rick", "123", "123", :postpaid)

    assert Postpaid.make_call("123", DateTime.utc_now(), 5) ==
      {:ok, "Call was successfull! Duration: 5 minutes."}
  end

  test "should print the client's invoice of the month" do
    Subscriber.create("Rick", "123", "123", :postpaid)
    date = DateTime.utc_now()
    old_date = ~U[2021-12-03 19:15:03.283786Z]
    Postpaid.make_call("123", date, 3)
    Postpaid.make_call("123", old_date, 3)
    Postpaid.make_call("123", date, 3)
    Postpaid.make_call("123", date, 3)

    subscriber = Subscriber.search_subscriber("123", :postpaid)
    assert Enum.count(subscriber.calls) == 4

    subscriber = Postpaid.print_bill(date.month, date.year, "123")

    assert subscriber.number == "123"
    assert Enum.count(subscriber.calls) == 3
    assert subscriber.plan.value == 12.599999999999998
  end
end
