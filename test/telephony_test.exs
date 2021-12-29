defmodule TelephonyTest do
  use ExUnit.Case
  doctest Telephony

  describe "Responsible for the telephony actions" do
    test "start/0 will start create needed files" do
      assert Telephony.start() == :ok
      assert File.exists?("pre.txt")
      assert File.exists?("post.txt")
    end
  end
end
