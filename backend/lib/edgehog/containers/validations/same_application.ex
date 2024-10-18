defmodule Edgehog.Containers.Validations.SameApplication do
  @moduledoc false

  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def validate(changeset, opts, _context) do
    release_a = Ash.Changeset.get_argument(changeset, opts[:release_a])
    release_b = Ash.Changeset.get_argument(changeset, opts[:release_b])

    if release_a.application_id == release_b.application_id do
      :ok
    else
      {:error, field: opts[:release_b], message: "must belong to the same application as from"}
    end
  end
end
