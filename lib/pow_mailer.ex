defmodule Trivium.PowMailer do
  @moduledoc false
  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :trivium
  import Bamboo.Email
  import Bamboo.SendGridHelper
  # require Logger

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email
    |> to(user.email)
    |> from("noreply@trivium.gg")
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  def password_reset(%{user: user, reset_token: reset_token}) do
    new_email
    |> with_template("d-f890e6e445824848a07f84499b019d1c")
    |> to(user.email)
    |> from("noreply@trivium.gg")
    |> add_dynamic_field("uuid", reset_token)
  end

  def activate_account(%{user: user, reset_token: reset_token}) do
    new_email
    |> with_template("d-68f5442cf3854f5b82aba7075a52204d")
    |> to(user.email)
    |> from("noreply@trivium.gg")
    |> add_dynamic_field("uuid", reset_token)
  end

  def process(email) do
    deliver_now(email)
  end

  # def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
  #   # Build email struct to be used in `process/1`

  #   %{to: user.email, subject: subject, text: text, html: html}
  # end

  # def process(email) do
  #   # Send email

  #   Logger.debug("E-mail sent: #{inspect(email)}")
  # end
end
