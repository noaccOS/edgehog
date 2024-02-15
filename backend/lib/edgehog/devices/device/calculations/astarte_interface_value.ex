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

defmodule Edgehog.Devices.Device.Calculations.AstarteInterfaceValue do
  use Ash.Calculation

  @impl true
  def load(_query, _opts, _context) do
    [:device_id, :appengine_client]
  end

  @impl true
  def calculate(devices, opts, _context) do
    Enum.map(devices, fn device ->
      %{
        device_id: device_id,
        appengine_client: client
      } = device

      fetch_fun = value_id_to_fetch_fun(opts[:value_id])

      case fetch_fun.(client, device_id) do
        {:ok, result} -> result
        {:error, _reason} -> nil
      end
    end)
  end

  @base_image Application.compile_env(
                :edgehog,
                :astarte_base_image_module,
                Edgehog.Astarte.Device.BaseImage
              )

  @os_info Application.compile_env(
             :edgehog,
             :astarte_os_info_module,
             Edgehog.Astarte.Device.OSInfo
           )

  @wifi_scan_result Application.compile_env(
                      :edgehog,
                      :astarte_wifi_scan_result_module,
                      Edgehog.Astarte.Device.WiFiScanResult
                    )

  defp value_id_to_fetch_fun(:base_image_info), do: &@base_image.get/2
  defp value_id_to_fetch_fun(:os_info), do: &@os_info.get/2
  defp value_id_to_fetch_fun(:wifi_scan_result), do: &@wifi_scan_result.get/2
end
