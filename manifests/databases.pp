# Wrapper class useful for hiera based deployments

class mongodb::databases(
  $dbs = undef
) {

  if $dbs {
    create_resources(mongodb::db, $dbs)
  }

}
