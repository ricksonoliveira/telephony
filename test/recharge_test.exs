defmodule RechargeTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  test "Should make a recharge" do
    Subscriber.create("Rick", "123", "123", :prepaid)

    {:ok, msg} = Recharge.new(DateTime.utc_now(), 30, "123")
    assert msg == "Recharged Successfully!"

    subscriber = Subscriber.search_subscriber("123", :prepaid)
    assert subscriber.plan.credits == 30
    assert Enum.count(subscriber.plan.recharges) == 1
  end
end
