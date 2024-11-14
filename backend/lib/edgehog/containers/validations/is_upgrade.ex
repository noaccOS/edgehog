#
# This file is part of Edgehog.
#
# Copyright 2024 SECO Mind Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
#

defmodule Edgehog.Containers.Validations.IsUpgrade do
  @moduledoc false

  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def validate(changeset, opts, _context) do
    with {:ok, from} <- Ash.Changeset.fetch_argument(changeset, opts[:from]),
         {:ok, to} <- Ash.Changeset.fetch_argument(changeset, opts[:to]),
         {:ok, from} <- Ash.load(from, [:release], lazy?: true, reuse_values?: true),
         {:ok, to} <- Ash.load(to, [:release], lazy?: true, reuse_values?: true) do
      from_version = parse_version(from)
      to_version = parse_version(to)

      if Version.compare(to_version, from_version) == :gt do
        :ok
      else
        {:error, field: opts[:to], message: "must be a newer release than from"}
      end
    end
  end

  defp parse_version(deployment) do
    with :error <- deployment.release.version |> get_in() |> to_string() |> Version.parse() do
      {:error, :invalid_release}
    end
  end
end
