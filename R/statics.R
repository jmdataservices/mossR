#' Standardised theme for mossR
#'
#' Does not currently include standardised format.

theme_moss <- function() {
        ggplot2::theme_minimal() +
        ggplot2::theme(
                panel.grid = ggplot2::element_blank(),
                panel.background = ggplot2::element_rect(fill = "white", color = "white"),
                plot.background = ggplot2::element_rect(fill = "white", color = "white"),
                plot.title = ggplot2::element_text(size = 22, hjust = 0.5),
                plot.subtitle = ggplot2::element_text(size = 18, hjust = 0.5),
                plot.caption = ggplot2::element_text(size = 11, face = "italic"),
                axis.title = ggplot2::element_text(size = 16, face = "bold", color = "grey40"),
                axis.text = ggplot2::element_text(size = 14, color = "grey60"),
                strip.text = ggplot2::element_text(size = 16, face = "bold", color = "grey40"),
                strip.background = ggplot2::element_rect(color = "white"),
                legend.title = ggplot2::element_blank(),
                legend.position = "none"
        )
}

#' Standardised color set for mossR
#'
#' Currently includes only 'lows' and 'highs'.

colors_moss <- list(
        lows = c("azure2", "snow", "whitesmoke", "grey90", "seagreen"),
        highs = c("firebrick1", "indianred", "hotpint", "cyan", "chartreuse")
)
