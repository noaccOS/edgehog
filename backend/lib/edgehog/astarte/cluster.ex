#
# This file is part of Edgehog.
#
# Copyright 2021-2023 SECO Mind Srl
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

defmodule Edgehog.Astarte.Cluster do
  use Ecto.Schema
  import Ecto.Changeset

  alias Edgehog.Astarte.Realm

  schema "clusters" do
    field :base_api_url, :string
    field :name, :string
    has_many :realms, Realm

    timestamps()
  end

  @doc false
  def changeset(cluster, attrs) do
    cluster
    |> cast(attrs, [:name, :base_api_url])
    |> validate_required([:name, :base_api_url])
    |> unique_constraint(:name)
    |> validate_change(:base_api_url, &validate_url/2)
  end

  defp validate_url(field, url) do
    %URI{scheme: scheme, host: maybe_host} = URI.parse(url)

    host = to_string(maybe_host)
    empty_host? = host == ""
    space_in_host? = host =~ " "

    valid_host? = not empty_host? and not space_in_host?
    valid_scheme? = scheme in ["http", "https"]

    if valid_host? and valid_scheme? do
      []
    else
      [{field, "is not a valid URL"}]
    end
  end
end
