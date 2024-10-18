defmodule Tmp do
  @moduledoc false
  use ExUnit.Case

  alias Edgehog.Containers.Deployment
  alias Edgehog.Containers.Release
  alias Edgehog.DevicesFixtures
  alias Edgehog.TenantsFixtures

  test "tmp" do
    me = self()
    tenant = TenantsFixtures.tenant_fixture()
    device = DevicesFixtures.device_fixture(tenant: tenant)

    application =
      Ash.create!(Edgehog.Containers.Application, %{name: "a", description: ""}, tenant: tenant)

    release_a =
      Ash.create!(Release, %{application_id: application.id, version: "0.0.1"}, tenant: tenant)

    release_b =
      Ash.create!(Release, %{application_id: application.id, version: "0.0.2"}, tenant: tenant)

    deployment_a =
      Ash.create!(Deployment, %{device_id: device.id, release_id: release_a.id}, tenant: tenant)

    deployment_b =
      Ash.create!(Deployment, %{device_id: device.id, release_id: release_b.id}, tenant: tenant)

    Mox.expect(
      Edgehog.Astarte.Device.DeploymentCommandMock,
      :send_deployment_command,
      fn _, ^device.id, ^deployment_a.id, command -> send(me, command) end
    )

    device
    |> Ash.Changeset.for_update(:send_application_command, )
  end
end
