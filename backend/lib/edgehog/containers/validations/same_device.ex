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

defmodule Edgehog.Containers.Validations.SameDevice do
  @moduledoc false

  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def validate(changeset, opts, _context) do
    with {:ok, deployment_a} <- Ash.Changeset.fetch_argument(changeset, opts[:deployment_a]),
         {:ok, deployment_b} <- Ash.Changeset.fetch_argument(changeset, opts[:deployment_b]) do
      device_a = deployment_a.device_id
      device_b = deployment_b.device_id

      if device_a == device_b do
        :ok
      else
        {:error, field: opts[:deployment_b], message: "must belong to the same device as from"}
      end
    end
  end
end
