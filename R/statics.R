#' Standardised theme for mossR
#'
#' Does not currently include standardised format.

theme_moss <- function() {
        theme_minimal() +
        theme(
                panel.grid = element_blank(),
                plot.title = element_text(size = 22, hjust = 0.5),
                plot.subtitle = element_text(size = 18, hjust = 0.5),
                plot.caption = element_text(size = 11, face = "italic"),
                axis.title = element_text(size = 16, face = "bold", color = "grey40"),
                axis.text = element_text(size = 14, color = "grey60"),
                strip.text = element_text(size = 16, face = "bold", color = "grey40"),
                strip.background = element_rect(color = NULL),
                legend.title = element_blank(),
                legend.position = "none"
        )
}

#' Standardised color set for mossR
#'
#' Currently includes only 'lows' and 'highs'.

colors_moss <- list(
        lows <- c("azure2", "snow", "whitesmoke", "grey90", "seagreen"),
        highs <- c("firebrick1", "indianred", "hotpint", "cyan", "chartreuse")
)
