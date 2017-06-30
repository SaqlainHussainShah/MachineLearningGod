library(ggplot2)
library(Cairo)

a <- seq(-5, 5, 0.001)

inv_logit <- function(a) {
  1 / (1 + exp(-a))
}

CairoWin()

ggplot(data.frame(a), aes(x = a)) +
  stat_function(fun = inv_logit, geom = "line") +
  xlab('\na') +
  ylab('p\n') +
  theme_bw() +
  theme(
    text = element_text(size = 30),
    axis.text = element_text(size = 30),
    plot.title = element_text(hjust = 0.5, size = 30)
  ) +
  ggtitle('sigmoid(a)\n') +
  scale_x_continuous(breaks = seq(-5, 5, 5)) +
  scale_y_continuous(breaks = seq(0, 1, 0.5))

ggsave(file = 'inv_logit.png', type = 'cairo-png')
