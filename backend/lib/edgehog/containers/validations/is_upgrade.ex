defmodule Edgehog.Containers.Validations.IsUpgrade do
  @moduledoc false

  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def validate(changeset, opts, _context) do
    from = Ash.Changeset.get_argument(changeset, opts[:from])
    to = Ash.Changeset.get_argument(changeset, opts[:to])

    from_version = Version.parse!(from.version)
    to_version = Version.parse!(to.version)

    if Version.compare(to_version, from_version) == :gt do
      :ok
    else
      {:error, field: opts[:to], message: "must be a newer release than from"}
    end
  end
end
