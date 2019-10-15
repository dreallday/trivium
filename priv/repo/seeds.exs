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
