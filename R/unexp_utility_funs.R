
ensure_paths_are_valid <- function(paths) {
  ensure_paths_not_empty(paths)
  ensure_paths_exist(paths)
}



ensure_paths_not_empty <- function(paths) {
  stopifnot(
    "`paths` should have at least one path to an R script." =
      is.character(paths) & length(paths) >= 1
  )
}



ensure_paths_exist <- function(paths) {
  res <- file.exists(paths)

  if (any(res) == FALSE) {
    stop(
      "Files were not found:\n",
      paste(paths[which(res == FALSE)], collapse = "\n")
    )
  }

  return(paths)
}
