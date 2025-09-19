
#' Run several R scripts at the same time
#'
#' Scripts are run in separate RStudio Background Jobs.
#' The function only continues if all scripts succeed;
#' encountering an Error in a script, or cancelling one
#' of the jobs in the Background Jobs pane, will cause
#' the function to return an Error.
#'
#' @param paths (Character) Paths to one or more R scripts.
#'
#' @returns A Character string. "Success" for success, and
#'   an error message for failure.
#' @export
#'
run_in_parallel <- function(paths) {
  ensure_paths_are_valid(paths)

  new_jobs <-
    Map(
      rstudioapi::jobRunScript,
      paths
    )

  job_status <- character(length = length(new_jobs))

  while (TRUE) {
    job_status <- sapply(new_jobs, rstudioapi::jobGetState)

    # I handle specific results from jobGetState() below.
    # Other unhandled results are "idle" and "running".

    if (any(job_status == "failed")) {
      stop(
        "Job(s) failed:\n",
        paste(names(which(job_status == "failed")), collapse = "\n")
      )
    }

    if (any(job_status == "cancelled")) {
      stop(
        "Job(s) cancelled:\n",
        paste(names(which(job_status == "cancelled")), collapse = "\n")
      )
    }

    if (all(job_status == "succeeded")) {
      message("All jobs succeeded.")
      return(invisible("Success\n"))
    }

    Sys.sleep(2)
  }

  return(invisible("Success\n"))
}
