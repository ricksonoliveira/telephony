defmodule SubscriberReadTest do
  use ExUnit.Case

  test "should return error for when file not exists" do
    assert Subscriber.read(:prepaid) ==
      {:error, "Invalid File."}
  end
end
