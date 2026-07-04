defmodule AppTest do
  use ExUnit.Case, async: true

  describe "bump_major/1" do
    test "bumps major and resets the rest" do
      assert App.bump_major("1.2.3") == {:ok, "2.0.0"}
    end

    test "propagates parse errors untouched" do
      assert {:error, "not a semver string:" <> _rest} = App.bump_major("nonsense")
    end
  end
end
