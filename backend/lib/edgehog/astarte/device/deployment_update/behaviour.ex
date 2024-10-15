defmodule Edgehog.Astarte.Device.DeploymentUpdate.Behaviour do
  @moduledoc false

  alias Astarte.Client.AppEngine

  @callback update(
              client :: AppEngine.t(),
              device_id :: String.t(),
              from :: String.t(),
              to :: String.t()
            ) :: :ok | {:error, term()}
end
