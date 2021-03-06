defmodule SubscriberTest do
  use ExUnit.Case
  doctest Subscriber

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "Responsible for the subscriptions" do
    test "should return subscriber structure" do
      assert %Subscriber{name: "Ana", number: "test", itin: "test", plan: "plan"}.name == "Ana"
    end

    test "create a prepaid subscriber" do
      assert Subscriber.create("Rick", "123", "123", :prepaid) ==
        {:ok, "Hello Rick, your subscription was created successfully!"}
    end

    test "should return error that subscriber already exists" do
      Subscriber.create("Rick", "123", "123", :prepaid)

      assert Subscriber.create("Rick", "123", "123", :prepaid) ==
        {:error, "Subscriber with this number already exists!"}
    end
  end

  describe "Responsible for the subscribers search" do
    test "search postpaid" do
      Subscriber.create("Rick", "123", "123", :postpaid)

      assert Subscriber.search_subscriber("123", :postpaid).name == "Rick"
      assert Subscriber.search_subscriber("123", :postpaid).plan.__struct__ == Postpaid
    end

    test "search prepaid" do
      Subscriber.create("Rick", "123", "123", :prepaid)

      assert Subscriber.search_subscriber("123", :prepaid).name == "Rick"
      assert Subscriber.search_subscriber("123", :prepaid).plan.__struct__ == Prepaid
    end
  end

  describe "Delete subscribers" do
    test "Should delete subscriber" do
      Subscriber.create("Rick", "123", "123", :prepaid)
      Subscriber.create("Ana", "222", "87654", :prepaid)
      assert Subscriber.delete("123") == {:ok, "Subscriber Rick deleted!"}
    end
  end
end
