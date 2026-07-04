defmodule App.Core do
  @moduledoc """
  Placeholder domain logic. Replace with real code; keep the error discipline:
  tagged tuples for expected failures, no silent fallbacks.
  """

  @type semver :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}

  @spec parse_semver(String.t()) :: {:ok, semver()} | {:error, String.t()}
  def parse_semver(value) when is_binary(value) do
    case String.split(value, ".") do
      [major, minor, patch] -> to_semver(major, minor, patch, value)
      _other -> {:error, "not a semver string: #{inspect(value)}"}
    end
  end

  defp to_semver(major, minor, patch, original) do
    case {parse_part(major), parse_part(minor), parse_part(patch)} do
      {{:ok, maj}, {:ok, min}, {:ok, pat}} -> {:ok, {maj, min, pat}}
      _other -> {:error, "non-numeric component in #{inspect(original)}"}
    end
  end

  defp parse_part(part) do
    case Integer.parse(part) do
      {number, ""} when number >= 0 -> {:ok, number}
      _other -> :error
    end
  end
end
