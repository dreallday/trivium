defmodule TriviumWeb.Phoenix.ControllerCallbacks do
  @moduledoc false
  use Pow.Extension.Phoenix.ControllerCallbacks.Base

  # def before_process do
  # end

  def before_respond(TriviumWeb.RegistrationController, :create, {:ok, user, conn}, _config) do
    # send email
    user |> IO.inspect(label: "before_respond user")
    {:ok, user, conn}
  end
end
