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

defmodule Edgehog.Devices.Device.ManualActions.UpdateApplication do
  @moduledoc false
  use Ash.Resource.ManualUpdate

  alias Edgehog.Error.AstarteAPIError

  @deployment_update Application.compile_env(
                       :edgehog,
                       :astarte_deployment_update_module,
                       Edgehog.Astarte.Device.DeploymentUpdate
                     )

  @impl Ash.Resource.ManualUpdate
  def update(changeset, _opts, _context) do
    from = changeset.arguments.release_from_id
    to = changeset.arguments.release_to_id
    device = changeset.data

    with {:ok, device} <- Ash.load(device, :appengine_client) do
      case @deployment_update.update(device.appengine_client, device.device_id, from, to) do
        :ok ->
          {:ok, device}

        {:error, api_error} ->
          reason =
            AstarteAPIError.exception(status: api_error.status, response: api_error.response)

          {:error, reason}
      end
    end
  end
end
