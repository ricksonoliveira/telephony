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
end
