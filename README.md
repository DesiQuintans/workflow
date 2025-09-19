# workflow - Run sets of R scripts one-by-one (sequentially) or simultaneously (in parallel).

## Functions

`workflow` provides these functions:

| Function             | Task                                                                                           |
|----------------------|------------------------------------------------------------------------------------------------|
| `run_sequentially()` | Runs each file in turn, continuing only if the previous file was successful.                   |
| `run_in_parallel()`  | Runs all files simultaneously. Raises an Error if any of them are cancelled or produce Errors. |


## Context

`workflow` is a lightweight package that uses RStudio's Background Jobs functionality to automate an analysis pipeline. 
For example, your analysis would be split into several R scripts that each handle a particular task, and then you would 
write a "Build everything" script that looks like this:

```r
# 1. Build the dataset by running these files one-after-another.

workflow::run_sequentially(
  c(
    "Import_data.R",
    "Create_variables.R",
    "Finalise_dataset.R"
  )
)


# 2. If there were no errors, run these scripts all at the same time in 
# separate processes, as they have no dependencies on each other.

workflow::run_in_parallel(
  c(
    "Fit_logistic_regression_models.R",
    "Fit_survival_models.R",
    "Descriptive_tables.R",
    "Figures.R"
  )
)


# 3. If there were still no errors, run this script, which depends on the
# output of the models from the last step.

workflow::run_sequentially(
  c(
    "Tabular_summaries_of_models.R"
  )
)


# 4. Finally, a regular call to render a Quarto document that assembles
# all of the tables and figures that were just created.

quarto::quarto_render(
  input       = "statistical_report.qmd",
  output_file = paste0(Sys.Date(), " - Statistical Report.docx")
)
```


## Advantages of `workflow`

1. Since all scripts are run as Background Jobs, you can keep working in 
   the foreground without having your Console tied up, and without having 
   objects in your Environment changed.
2. Background Jobs are integrated into RStudio, so you can see which part of 
   the script is running, how long it has taken, etc.
3. Background Jobs are run in isolated environments; there is no carry-over of 
   objects in the global Environment. This helps ensure reproducibility.
4. Being able to define when scripts run sequentially or in parallel makes 
   the most of the computational power you have.


## Downsides of `workflow`

1. Requires RStudio. Writing this using a package like `callr` would make more 
   sense if the code needed to be run outside RStudio.
2. No logging. As of 2025-09-19, `workflow` has no logging functionality 
   that captures what a script contains, what its output was, what its running 
   environment was, etc. The [`whirl`](https://github.com/NovoNordisk-OpenSource/whirl) 
   package has this, but `whirl`'s big issue right now is that it does not respect 
   Errors (see <https://github.com/NovoNordisk-OpenSource/whirl/issues/202>).
