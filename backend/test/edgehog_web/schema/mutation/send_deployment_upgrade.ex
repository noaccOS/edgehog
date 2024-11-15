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

defmodule EdgehogWeb.Schema.Mutation.SendDeploymentUpgradeTest do
  @moduledoc false
  use EdgehogWeb.GraphqlCase, async: true

  import Edgehog.ContainersFixtures

  alias Edgehog.Astarte.Device.DeploymentCommandMock

  describe "sendDeploymentUpgrade" do
    test "correctly sends the deployment upgrade with valid data", %{tenant: tenant} do
      deployment = deployment_fixture(tenant: tenant)

      expect(DeploymentCommandMock, :send_deployment_command, 1, fn _, _, _ -> :ok end)

      [tenant: tenant, deployment: deployment]
      |> send_start_deployment_mutation()
      |> extract_result!()
    end

    test "fails if the deployments do not belong to the same device" do
      deployment = deployment_fixture(tenant: tenant)

      deployment = deployment |> Ash.Changeset.for_destroy(:destroy) |> Ash.destroy!()

      [tenant: tenant, deployment: deployment]
      |> send_start_deployment_mutation()
      |> extract_error!()
    end

    test "fails if the deployments do not belong to the same application" do
    end

    test "fails if the second deployment does not have a greater version than the first" do
    end
  end

  defp send_start_deployment_mutation(opts) do
    default_document = """
    mutation SendDeploymentUpgrade($input: SendDeploymentUpgradeInput!) {
      sendDeploymentUpgrade(input: $input) {
        result {
          id
        }
      }
    }
    """

    {tenant, opts} = Keyword.pop!(opts, :tenant)
    {deployment, opts} = Keyword.pop!(opts, :deployment)

    {device_id, opts} =
      Keyword.pop_lazy(opts, :device_id, fn ->
        [tenant: tenant]
        |> device_fixture()
        |> AshGraphql.Resource.encode_relay_id()
      end)

    input = %{
      "id" => deployment.id
    }

    variables = %{
      "input" => input
    }

    document = Keyword.get(opts, :document, default_document)

    Absinthe.run!(document, EdgehogWeb.Schema, variables: variables, context: %{tenant: tenant})
  end

  def extract_result!(result) do
    assert %{
             data: %{
               "startDeployment" => %{
                 "result" => deployment
               }
             }
           } = result

    refute :errors in Map.keys(result)
    assert deployment != nil

    deployment
  end

  defp extract_error!(result) do
    assert %{
             data: %{
               "startDeployment" => %{"result" => nil}
             },
             errors: [error]
           } = result

    error
  end
end
