
#' Run several R scripts one after the other
#'
#' Each script is run as an RStudio Background Job,
#' with the next job being started only when the previous
#' jobs report success. Encountering an Error in a script,
#' or cancelling one of the jobs in the Background Jobs
#' pane, will cause the function to return an Error.
#'
#' @param paths (Character) Paths to one or more R scripts.
#'
#' @returns A Character string. "Success" for success, and
#'   an error message for failure.
#' @export
run_sequentially <- function(paths) {
  ensure_paths_are_valid(paths)

  for (i in seq_along(paths)) {
    run_in_parallel(paths[i])
  }
}
