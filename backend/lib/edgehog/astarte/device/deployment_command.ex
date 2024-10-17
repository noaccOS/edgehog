defmodule Edgehog.Astarte.Device.DeploymentCommand do
  @moduledoc false

  @behaviour Edgehog.Astarte.Device.DeploymentCommand.Behaviour

  alias Astarte.Client.AppEngine

  @interface "io.edgehog.devicemanager.apps.DeploymentCommand"

  @impl Edgehog.Astarte.Device.DeploymentCommand.Behaviour
  def send_deployment_command(client, device_id, deployment_id, command) do
    path = "/#{deployment_id}/command"
    AppEngine.Devices.send_datastream(client, device_id, @interface, path, command)
  end
end
