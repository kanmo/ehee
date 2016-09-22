defmodule Ehee.Credential do
  defstruct auth: nil

  @type auth :: %{user: binary, password: binary} | %{access_token: binary}
  @type t :: %__MODULE__{auth: auth}

  @spec new(auth) :: t
  def new(auth), do: %__MODULE__{auth: auth}
end
