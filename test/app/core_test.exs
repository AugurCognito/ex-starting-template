defmodule App.CoreTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias App.Core

  describe "parse_semver/1" do
    test "parses a valid semver" do
      assert Core.parse_semver("1.2.3") == {:ok, {1, 2, 3}}
    end

    test "rejects wrong arity" do
      assert {:error, "not a semver string:" <> _rest} = Core.parse_semver("1.2")
    end

    test "rejects non-numeric components" do
      assert {:error, "non-numeric component in" <> _rest} = Core.parse_semver("1.x.3")
    end

    test "rejects negative components" do
      assert {:error, _reason} = Core.parse_semver("1.-2.3")
    end

    property "round-trips any generated version triple" do
      check all(
              major <- non_negative_integer(),
              minor <- non_negative_integer(),
              patch <- non_negative_integer()
            ) do
        assert Core.parse_semver("#{major}.#{minor}.#{patch}") == {:ok, {major, minor, patch}}
      end
    end
  end
end
