library(ggplot2)
library(Cairo)

p <- seq(0, 1, 0.001)

ln_odds <- function(p) {
  log(p / (1 - p))
}

CairoWin()

ggplot(data.frame(p), aes(x = p)) +
  stat_function(fun = ln_odds, geom = "line") +
  xlab('\np') +
  ylab('a\n') +
  theme_bw() +
  theme(
    text = element_text(size = 30),
    axis.text = element_text(size = 30),
    plot.title = element_text(hjust = 0.5, size = 30)
  ) +
  ggtitle('logit(p)\n') +
  scale_x_continuous(breaks = seq(0, 1, 0.5)) +
  scale_y_continuous(breaks = seq(-5, 5, 5))

ggsave(file = 'logit.png', type = 'cairo-png')
