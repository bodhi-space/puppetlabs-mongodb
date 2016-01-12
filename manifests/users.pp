# Wrapper class useful for hiera based deployments

class mongodb::users(
  $users = undef
) {

  if $users {
    create_resources(mongodb_user, $users)
  }

  Mongodb_database <| |> -> Mongodb_user <| |>

}

