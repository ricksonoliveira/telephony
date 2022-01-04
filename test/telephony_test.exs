defmodule TelephonyTest do
  use ExUnit.Case
  doctest Telephony

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "Responsible for the telephony actions" do

    test "Should test structure" do
      assert Telephony.create_subscriber("Rick", "123", "123", :prepaid) ==
               {:ok, "Hello Rick, your subscription was created successfully!"}
    end

    test "list subscribers" do
      Telephony.create_subscriber("Rick", "123", "123", :prepaid)
      assert Telephony.list_subscribers() |> Enum.count() ==
               1
    end

    test "list prepaid subscribers" do
      Telephony.create_subscriber("Rick", "123", "123", :prepaid)
      assert Telephony.list_prepaid_subscribers() |> Enum.count() ==
               1
    end

    test "list pospaid subscribers" do
      Telephony.create_subscriber("Ana", "123", "123", :postpaid)
      assert Telephony.list_postpaid_subscribers() |> Enum.count() ==
               1
    end

    test "make call postpaid" do
      Telephony.create_subscriber("Ana", "123", "123", :postpaid)
      assert Telephony.make_call("123", :postpaid, DateTime.utc_now(), 10) ==
               {:ok, "Call was successfull! Duration: 10 minutes."}
    end

    test "make call prepaid" do
      Telephony.create_subscriber("Rick", "123", "123", :prepaid)
      Telephony.recharge("123", DateTime.utc_now(), 100)

      assert Telephony.make_call("123", :prepaid, DateTime.utc_now(), 10) ==
               {:ok, "This call costed 14.5, you have 85.5 credits."}
    end

    test "search subscriber by number" do
      Telephony.create_subscriber("Rick", "123", "123", :prepaid)
      assert Telephony.search_by_number("123")
    end

    test "print bills" do
      Telephony.create_subscriber("Rick", "123", "123", :prepaid)
      Telephony.create_subscriber("Ana", "1234", "123", :postpaid)

      date = DateTime.utc_now()
      assert Telephony.print_bills(date.month, date.year)
      == :ok

    end

    test "start/0 will start create needed files" do
      assert Telephony.start() == :ok
      assert File.exists?("pre.txt")
      assert File.exists?("post.txt")
    end
  end
end
