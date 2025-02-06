# Load required libraries
library(FGN)
library(stats)
library(ggplot2)

# Function to process time series
batch_process <- function(data_list, lag = 10) {
    results <- lapply(data_list, function(series) {
        if (all(is.na(series))) {
            return(list(hurst = NA, ljung_pval = NA))
        }
        
        # Calculate Hurst exponent with error handling
        hurst_val <- tryCatch(HurstK(series), error = function(e) NA)
        
        # Calculate Ljung-Box test with error handling
        ljung_test <- tryCatch(Box.test(series, lag = lag, type = "Ljung-Box"), error = function(e) NA)
        
        # Extract p-value if Ljung-Box test was successful
        ljung_pval <- if (is.list(ljung_test) && "p.value" %in% names(ljung_test)) {
            ljung_test$p.value
        } else {
            NA
        }
        
        return(list(hurst = hurst_val, ljung_pval = ljung_pval))
    })
    return(results)
}

# Smoothing function
smooth_series <- function(series, window) {
    stats::filter(series, rep(1 / window, window), sides = 2, circular = TRUE)
}

# Set parameters
set.seed(42)  # For reproducibility
iterations <- 100       # Number of iterations
series_length <- 3000   # Length of each time series
window_sizes <- seq(5, 100, by = 5)  # Range of smoothing window sizes

# Generate Random time series
group1_data <- replicate(iterations, rnorm(series_length), simplify = FALSE)

# Select a single time series to illustrate smoothing
example_series <- group1_data[[1]]

# Apply different levels of smoothing and calculate Hurst exponents
example_smoothing_results <- lapply(c(NA, 10, 50, 100), function(window_size) {
    if (is.na(window_size)) {
        smoothed_series <- example_series
        hurst <- tryCatch(HurstK(example_series), error = function(e) NA)
        list(smoothed_series = smoothed_series, hurst = hurst, window_size = "Not Smoothed")
    } else {
        smoothed_series <- smooth_series(example_series, window = window_size)
        hurst <- tryCatch(HurstK(smoothed_series), error = function(e) NA)
        list(smoothed_series = smoothed_series, hurst = hurst, window_size = window_size)
    }
})

# Generate separate plots for each smoothing level
for (result in example_smoothing_results) {
    smoothing_level <- ifelse(result$window_size == "Not Smoothed", 
                              "Original (Not Smoothed)", 
                              paste("Window =", result$window_size))
    hurst_value <- round(result$hurst, 2)
    
    plot_title <- paste(smoothing_level, "\nHurst =", hurst_value)
    
    smoothing_plot <- ggplot(data.frame(time = seq_along(result$smoothed_series), 
                                        value = result$smoothed_series), aes(x = time, y = value)) +
        geom_line(color = "blue", size = 0.8) +
        labs(
            title = plot_title,
            x = "Time",
            y = "Value"
        ) +
        theme_minimal() +
        theme(aspect.ratio = 9 / 16)  # Landscape proportion
    
    print(smoothing_plot)
}

# Process time series with varying smoothing window sizes
results_by_window <- lapply(window_sizes, function(window_size) {
    # Smooth the data
    smoothed_data <- lapply(group1_data, smooth_series, window = window_size)
    
    # Calculate Hurst exponents for smoothed data
    smoothed_results <- batch_process(smoothed_data)
    
    # Extract Hurst values
    hurst_values <- sapply(smoothed_results, `[[`, "hurst")
    
    # Create a data frame for this window size
    data.frame(
        window_size = window_size,
        hurst = hurst_values
    )
})

# Combine results into one data frame
results_df <- do.call(rbind, results_by_window)

# Check intermediate data
cat("Summary of Hurst Exponents:\n")
print(summary(results_df$hurst))

# Calculate correlation between window size and mean Hurst exponent
hurst_mean_by_window <- aggregate(hurst ~ window_size, data = results_df, mean, na.rm = TRUE)
correlation <- cor(hurst_mean_by_window$window_size, hurst_mean_by_window$hurst, use = "complete.obs")

# Print correlation
cat("Correlation between window size and Hurst exponent:", round(correlation, 2), "\n")

# Scatter plot with regression line
hurst_window_scatter <- ggplot(results_df, aes(x = window_size, y = hurst)) +
    geom_point(alpha = 0.6) +
    geom_smooth(method = "lm", color = "red", se = FALSE) +
    labs(
        title = paste("Hurst Exponent vs. Smoothing Window Size\nCorrelation =", round(correlation, 2)),
        x = "Smoothing Window Size",
        y = "Hurst Exponent"
    ) +
    theme_minimal()

# Print the scatter plot
print(hurst_window_scatter)

