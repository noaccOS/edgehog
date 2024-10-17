defmodule Edgehog.Containers.Validations.ApplicationUpgrade do
  @moduledoc false

  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def validate(changeset, _opts, _context) do
    from = changeset.arguments.from
    to = changeset.arguments.to

    if from.application_id == to.application_id do
      :ok
    else
      {:error, field: :to, message: "must belong to the same application as from"}
    end
  end
end
