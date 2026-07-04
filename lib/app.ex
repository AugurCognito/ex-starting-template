defmodule App do
  @moduledoc """
  Public surface. Callers go through this module; App.* internals are private
  to the library.
  """

  alias App.Core

  @spec bump_major(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def bump_major(version) do
    with {:ok, {major, _minor, _patch}} <- Core.parse_semver(version) do
      {:ok, "#{major + 1}.0.0"}
    end
  end
end
