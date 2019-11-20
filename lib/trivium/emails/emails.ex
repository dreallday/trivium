defmodule Trivium.Emails do
  @moduledoc false
  import Bamboo.Email

  def contact_email(%{"email" => email, "message" => message}) do
    new_email()
    |> to("andreifaa@gmail.com")
    |> from("noreply@trivium.gg")
    |> subject("Contact email")
    |> html_body("Email: #{email} Message: #{message}")
    |> text_body("Email: #{email} Message: #{message}")
  end
end
