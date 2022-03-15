#
# This file is part of Edgehog.
#
# Copyright 2022 SECO Mind Srl
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

defmodule Edgehog.Astarte.Device.LedBehavior do
  @behaviour Edgehog.Astarte.Device.LedBehavior.Behaviour

  alias Astarte.Client.AppEngine

  @interface "io.edgehog.devicemanager.LedBehavior"

  @impl true
  def post(%AppEngine{} = client, device_id, behavior) do
    AppEngine.Devices.send_datastream(
      client,
      device_id,
      @interface,
      "/indicator/behavior",
      behavior
    )
  end
end
