# == Class: mongodb::db
#
# Class for creating mongodb databases and users.
#
# == Parameters
#
#  user - Database username.
#  password_hash - Hashed password. Hex encoded md5 hash of "$username:mongo:$password".
#  password - Plain text user password. This is UNSAFE, use 'password_hash' unstead.
#  roles (default: ['dbAdmin']) - array with user roles.
#  tries (default: 10) - The maximum amount of two second tries to wait MongoDB startup.
#
define mongodb::db (
  $user           = undef,
  $users          = undef,
  $password_hash  = false,
  $password       = false,
  $roles          = ['dbAdmin'],
  $tries          = 10,
) {

  mongodb_database { $name:
    ensure => present,
    tries  => $tries
  }

  if $user && $users {
    fail("Parameters 'user' and 'users' to mongodb::db are mutually exclusive.")
  }

  if $user {
    if $password_hash {
      $hash = $password_hash
    } elsif $password {
      $hash = mongodb_password($user, $password)
    } else {
      fail("One of 'password_hash' or 'password' must be provided to mongodb::db when using the 'user' param.")
    }

    mongodb_user { "User ${user} on db ${name}":
      ensure        => present,
      password_hash => $hash,
      username      => $user,
      database      => $name,
      roles         => $roles,
      require       => Mongodb_database[$name],
    }
  } else {
    # Note:  password_hash is the only supported option on this code path - too much work
    # to iterate through the individual members and munge $password into the right format.
    if $users {
      create_resources(mongodb_user, $users)
    }

    Mongodb_database <| |> -> Mongodb_user <| |>

  }
}
