library(ggplot2)
library(Cairo)

x <- seq(0, 10, 0.1)
y <- 1 + 2 * x + rnorm(length(x)) * 5

mx <- mean(x)
my <- mean(y)
c1 <- sum((x - mx) * (y - my)) / sum((x - mx) ^ 2)
c0 <- my - c1 * mx

yf <- function(x) {
  c0 + c1 * x
}

CairoWin()

ggplot(data.frame(x, y), aes(x = x, y = y)) +
  geom_point(size = 4, col = 'blue') +
  stat_function(fun = yf, geom = "line", col = 'red', size = 2) +
  xlab('\nx') +
  ylab('y\n') +
  theme_bw() +
  theme(
    text = element_text(size = 20),
    axis.text = element_text(size = 20),
    plot.title = element_text(hjust = 0.5, size = 20)
  ) +
  ggtitle('Linear regression\n') +
  scale_x_continuous(breaks = seq(0, 10, 5), limits = c(0, 10)) +
  scale_y_continuous(breaks = seq(-40, 40, 40), limits = c(-40, 40))

ggsave(file = 'linear_regression.png', type = 'cairo-png')