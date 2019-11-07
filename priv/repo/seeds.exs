# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Trivium.Repo.insert!(%Trivium.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# Trivium.Repo.insert!()
# Trivium.Repo.insert!(%Trivium.Private.Token{
#   id: Ecto.UUID.generate(),
#   token:
#     :crypto.hmac(:sha, "secret", :crypto.strong_rand_bytes(6) |> Base.encode16(case: :lower))
#     |> Base.encode16(case: :lower),
#   user_id: 1
# })

trial_plan =
  Trivium.Repo.insert!(%Trivium.Billing.Plan{
    name: "Trial",
    price: 000,
    is_trial: true,
    price_per_call: 000,
    request_limit: 1,
    request_limit_interval: 1,
    request_per_day: 2500,
    user_limit: 10,
    plan_id: "prod_G0OqGaSyhcC5ru"
  })

user =
  Trivium.Repo.insert!(%Trivium.Users.User{
    email: "andreifaa@gmail.com",
    cus_id: "cus_EzS6hoeuxmRbrE",
    password_hash:
      "$pbkdf2-sha512$100000$LmxTpiX2a/9LujrZq6l74Q==$R7Lv4Q03EQbCzPDGZ/zhC0qFCiq4VFHkNjsJn5Cx5hEKvZAv/aDcx8PRfSBxKQRJZDw7CYZiKBgkY+ZNgvCekQ==",
    email_confirmed_at: DateTime.truncate(DateTime.utc_now(), :second),
    token_limit: 50
  })

Trivium.Repo.insert!(%Trivium.Private.Token{
  token: "8fe77011f770cc87f53f24aae713d8600c352602",
  user_id: user.id
})

Trivium.Repo.insert!(%Trivium.Billing.Plan{
  name: "Basic",
  price: 5000,
  price_per_call: 000,
  request_limit: 10,
  request_limit_interval: 1,
  request_per_day: 10000,
  user_limit: 6
})
