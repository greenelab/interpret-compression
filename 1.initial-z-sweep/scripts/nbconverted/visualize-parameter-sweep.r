
library(ggplot2)

set.seed(123)

`%>%` <- dplyr::`%>%`

source(file.path('scripts', 'viz_utils.R'))

# Set input file names and output directories
tcga_adage_file <- file.path("results", "param_sweep_adage_TCGA_full-results.tsv")
tcga_tybalt_file <- file.path("results", "param_sweep_tybalt_TCGA_full-results.tsv")
tcga_fig_dir <- file.path("figures", "tcga_results")

gtex_adage_file <- file.path("results", "param_sweep_adage_GTEX_full-results.tsv")
gtex_tybalt_file <- file.path("results", "param_sweep_tybalt_GTEX_full-results.tsv")
gtex_fig_dir <- file.path("figures", "gtex_results")

target_adage_file <- file.path("results", "param_sweep_adage_TARGET_full-results.tsv")
target_tybalt_file <- file.path("results", "param_sweep_tybalt_TARGET_full-results.tsv")
target_fig_dir <- file.path("figures", "target_results")

# Load and Process Data
tcga_tybalt <- processParamSweepResults(param_file = tcga_tybalt_file,
                                        dataset = "TCGA",
                                        algorithm = "Tybalt",
                                        output_fig_dir = tcga_fig_dir)

tcga_tybalt$final_val_plot + theme(text = element_text(size = 15))

tcga_tybalt$one_model_plot + theme(text = element_text(size = 15))

tcga_tybalt$all_results$best_params

tcga_tybalt_good_training_df <- tcga_tybalt$all_results$melt_df %>%
  dplyr::filter(batch_size == 50,
                epochs == 100,
                kappa == "0.0") %>%
  dplyr::filter(
    (learning_rate == "0.002" & num_components == 5) |
      (learning_rate == "0.0015" & num_components == 25) |
      (learning_rate == "0.0015" & num_components == 50) |
      (learning_rate == "0.0015" & num_components == 75) |
      (learning_rate == "0.001" & num_components == 100) |
      (learning_rate == "0.0005" & num_components == 125)
  ) %>%
  dplyr::mutate(
      num_components =
          factor(num_components,
                 levels = sort(as.numeric(paste(unique(num_components)))))
  )

plotBestModel(tcga_tybalt_good_training_df,
              dataset = "TCGA",
              algorithm = "Tybalt",
              output_fig_dir = tcga_fig_dir) + theme(text = element_text(size = 15))

# Load and Process Data
tcga_adage <- processParamSweepResults(param_file = tcga_adage_file,
                                       dataset = "TCGA",
                                       algorithm = "ADAGE",
                                       output_fig_dir = tcga_fig_dir)

tcga_adage$final_val_plot + theme(text = element_text(size = 15))

# Several hyperparameter combinations did not converge
# This was particularly a result of the low learning rates - filter and replot
tcga_adage_converge_df <- tcga_adage$all_results$select_df %>%
    dplyr::filter(end_loss < 0.01, learning_rate != 'Learn: 1e-05')

# Replot and Save Update
plotFinalLoss(tcga_adage_converge_df,
              dataset = "TCGA",
              algorithm = "ADAGE",
              output_fig_dir = tcga_fig_dir,
              plot_converge = TRUE) + theme(text = element_text(size = 15))

tcga_adage$one_model_plot + theme(text = element_text(size = 15))

tcga_adage$all_results$best_params

tcga_adage_good_training_df <- tcga_adage$all_results$melt_df %>%
  dplyr::filter(sparsity == "0.0",
                epochs == 100,
                batch_size == 50,
                noise == "0.0") %>%
  dplyr::filter(
    (num_components == 5 & learning_rate == "0.0015") |
      (num_components == 25 & learning_rate == "0.0015") |
      (num_components == 50 & learning_rate == "0.0005") |
      (num_components == 75 & learning_rate == "0.0005") |
      (num_components == 100 & learning_rate == "0.0005") |
      (num_components == 125 & learning_rate == "0.0005")
  ) %>%
  dplyr::mutate(
      num_components =
          factor(num_components,
                 levels = sort(as.numeric(paste(unique(num_components)))))
  )

plotBestModel(tcga_adage_good_training_df,
              dataset = "TCGA",
              algorithm = "ADAGE",
              output_fig_dir = tcga_fig_dir) + theme(text = element_text(size = 15))

# Load and process data
gtex_tybalt <- processParamSweepResults(param_file = gtex_tybalt_file,
                                        dataset = "GTEx",
                                        algorithm = "Tybalt",
                                        output_fig_dir = gtex_fig_dir)

gtex_tybalt$final_val_plot + theme(text = element_text(size = 15))

gtex_tybalt$one_model_plot + theme(text = element_text(size = 15))

gtex_tybalt$all_results$best_params

gtex_tybalt_good_training_df <- gtex_tybalt$all_results$melt_df %>%
  dplyr::filter(epochs == 100, kappa == 0.5) %>%
  dplyr::filter(
    (learning_rate == "0.0025" & batch_size == 100 & num_components == 5) |
      (learning_rate == "0.0025" & batch_size == 100 & num_components == 25) |
      (learning_rate == "0.002" & batch_size == 100 & num_components == 50) |
      (learning_rate == "0.002" & batch_size == 50 & num_components == 75) |
      (learning_rate == "0.0015" & batch_size == 50 & num_components == 100) |
      (learning_rate == "0.0015" & batch_size == 50 & num_components == 125)
  ) %>%
  dplyr::mutate(
      num_components =
          factor(num_components,
                 levels = sort(as.numeric(paste(unique(num_components)))))
  )

plotBestModel(gtex_tybalt_good_training_df,
              dataset = "GTEx",
              algorithm = "Tybalt",
              output_fig_dir = gtex_fig_dir) + theme(text = element_text(size = 15))

# Load and process data
gtex_adage <- processParamSweepResults(param_file = gtex_adage_file,
                                       dataset = "GTEx",
                                       algorithm = "ADAGE",
                                       output_fig_dir = gtex_fig_dir)

gtex_adage$final_val_plot + theme(text = element_text(size = 15))

# Several hyperparameter combinations did not converge
# This was particularly a result of the low learning rates - filter and replot
gtex_adage_converge_df <- gtex_adage$all_results$select_df %>%
    dplyr::filter(end_loss < 0.01, learning_rate != 'Learn: 1e-05')

# Replot and save update
plotFinalLoss(gtex_adage_converge_df,
              dataset = "GTEx",
              algorithm = "ADAGE",
              output_fig_dir = gtex_fig_dir,
              plot_converge = TRUE) + theme(text = element_text(size = 15))

gtex_adage$one_model_plot + theme(text = element_text(size = 15))

gtex_adage$all_results$best_params

gtex_adage_good_training_df <- gtex_adage$all_results$melt_df %>%
  dplyr::filter(sparsity == "0.0",
                epochs == 100,
                batch_size == 50) %>%
  dplyr::filter(
    (num_components == 5 & learning_rate == "0.001" & noise == "0.1") |
      (num_components == 25 & learning_rate == "0.001" & noise == "0.0") |
      (num_components == 50 & learning_rate == "0.0005" & noise == "0.0") |
      (num_components == 75 & learning_rate == "0.0005" & noise == "0.0") |
      (num_components == 100 & learning_rate == "0.0005" & noise == "0.0") |
      (num_components == 125 & learning_rate == "0.0005" & noise == "0.0")
  ) %>%
  dplyr::mutate(
      num_components =
          factor(num_components,
                 levels = sort(as.numeric(paste(unique(num_components)))))
  )

plotBestModel(gtex_adage_good_training_df,
              dataset = "GTEx",
              algorithm = "ADAGE",
              output_fig_dir = gtex_fig_dir) + theme(text = element_text(size = 15))

# Load and process data
target_tybalt <- processParamSweepResults(param_file = target_tybalt_file,
                                          dataset = "TARGET",
                                          algorithm = "Tybalt",
                                          output_fig_dir = target_fig_dir)

target_tybalt$final_val_plot + theme(text = element_text(size = 15))

target_tybalt$one_model_plot + theme(text = element_text(size = 15))

target_tybalt$all_results$best_params

target_tybalt_good_training_df <- target_tybalt$all_results$melt_df %>%
  dplyr::filter(batch_size == 25,
                epochs == 100,
                kappa == '0.5') %>%
  dplyr::filter(
    (num_components == 5 & learning_rate == "0.0015") |
      (num_components == 25 & learning_rate == "0.0015") |
      (num_components == 50 & learning_rate == "0.0015") |
      (num_components == 75 & learning_rate == "0.0015") |
      (num_components == 100 & learning_rate == "0.0015") |
      (num_components == 125 & learning_rate == "0.0005")
  ) %>%
  dplyr::mutate(
      num_components =
          factor(num_components,
                 levels = sort(as.numeric(paste(unique(num_components)))))
  )

plotBestModel(target_tybalt_good_training_df,
              dataset = "TARGET",
              algorithm = "Tybalt",
              output_fig_dir = target_fig_dir) + theme(text = element_text(size = 15))

# Load and process data
target_adage <- processParamSweepResults(param_file = target_adage_file,
                                         dataset = "TARGET",
                                         algorithm = "ADAGE",
                                         output_fig_dir = target_fig_dir)

target_adage$final_val_plot + theme(text = element_text(size = 15))

target_adage$one_model_plot + theme(text = element_text(size = 15))

target_adage$all_results$best_params

target_adage_good_training_df <- target_adage$all_results$melt_df %>%
  dplyr::filter(sparsity == "0.0",
                epochs == 100,
                batch_size == 50,
                noise == "0.1",
                learning_rate == "0.0005") %>%
  dplyr::mutate(
      num_components =
          factor(num_components,
                 levels = sort(as.numeric(paste(unique(num_components)))))
  )

plotBestModel(target_adage_good_training_df,
              dataset = "TARGET",
              algorithm = "ADAGE",
              output_fig_dir = target_fig_dir) + theme(text = element_text(size = 15))
