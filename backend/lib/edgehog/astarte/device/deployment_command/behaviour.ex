defmodule Edgehog.Astarte.Device.DeploymentCommand.Behaviour do
  @moduledoc false

  alias Astarte.Client.AppEngine

  @callback send_deployment_command(
              client :: AppEngine.t(),
              device_id :: String.t(),
              release_id :: String.t(),
              command :: String.t()
            ) ::
              :ok | {:error, term()}
end
