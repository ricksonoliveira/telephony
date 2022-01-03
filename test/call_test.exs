defmodule CallTest do
  use ExUnit.Case

  describe "Responsible for the calls" do
    test "should return call structure" do
      assert %Call{date: DateTime.utc_now(), duration: 30}.duration == 30
    end
  end
end
