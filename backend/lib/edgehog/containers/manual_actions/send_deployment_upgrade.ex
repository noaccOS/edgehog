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

defmodule Edgehog.Containers.ManualActions.SendDeploymentUpgrade do
  @moduledoc false

  use Ash.Resource.Actions.Implementation

  alias Edgehog.Devices

  @impl Ash.Resource.Actions.Implementation
  def run(input, opts, context) do
    with {:ok, from} <- Ash.Changeset.fetch_argument(input, opts[:from]),
         {:ok, to} <- Ash.Changeset.fetch_argument(input, opts[:to]),
         :ok <- SameDevice.validate(input, [deployment_a: :from, deployment_b: :to], context),
         :ok <-
           SameApplication.validate(input, [deployment_a: :from, deployment_b: :to], context),
         :ok <- IsUpgrade.validate(input, [from: :from, to: :to], context),
         {:ok, _device} <- Devices.update_application(from.device_id, from, to) do
      {:ok, :ok}
    end
  end
end
