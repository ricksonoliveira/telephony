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

      assert Prepaid.make_call("123", DateTime.utc_now(), 3) ==
        {:ok, "This call costed 4.35"}
    end
  end
end
