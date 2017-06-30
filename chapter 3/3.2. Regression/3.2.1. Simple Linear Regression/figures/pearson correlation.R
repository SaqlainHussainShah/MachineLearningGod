library(ggplot2)
library(Cairo)



# Pearson correlation = 1.

x <- seq(0, 10, 0.1)
c0 <- 1
c1 <- 2
y <- function(x) {
  c0 + c1 * x
}
cor(x, y(x), method = 'pearson')

CairoWin()

ggplot(data.frame(x), aes(x = x)) +
  stat_function(fun = y, geom = "line") +
  xlab('\nx') +
  ylab('y\n') +
  theme_bw() +
  theme(
    text = element_text(size = 40),
    axis.text = element_text(size = 40),
    plot.title = element_text(hjust = 0.5, size = 40)
  ) +
  ggtitle('r = 1\n') +
  scale_x_continuous(breaks = seq(0, 10, 5), limits = c(0, 10)) +
  scale_y_continuous(breaks = seq(-40, 40, 40), limits = c(-40, 40))

ggsave(file = 'pearson_1.png', type = 'cairo-png')



# Pearson correlation = 0.7.
y <- function(x) {
  c0 + c1 * x + rnorm(length(x)) * 5
}
cor(x, y(x), method = 'pearson')
yy <- y(x)

CairoWin()

ggplot(data.frame(x, yy), aes(x = x, y = yy)) +
  geom_point(size = 4) +
  xlab('\nx') +
  ylab('') +
  theme_bw() +
  theme(
    text = element_text(size = 40),
    axis.text = element_text(size = 40),
    plot.title = element_text(hjust = 0.5, size = 40)
  ) +
  ggtitle('r = 0.7\n') +
  scale_x_continuous(breaks = seq(0, 10, 5), limits = c(0, 10)) +
  scale_y_continuous(breaks = seq(-40, 40, 40), limits = c(-40, 40))

ggsave(file = 'pearson_2.png', type = 'cairo-png')



# Pearson correlation = 0.25.
y <- function(x) {
  c0 + c1 * x + rnorm(length(x)) * 15
}
cor(x, y(x), method = 'pearson')
yy <- y(x)

CairoWin()

ggplot(data.frame(x, yy), aes(x = x, y = yy)) +
  geom_point(size = 4) +
  xlab('\nx') +
  ylab('') +
  theme_bw() +
  theme(
    text = element_text(size = 40),
    axis.text = element_text(size = 40),
    plot.title = element_text(hjust = 0.5, size = 40)
  ) +
  ggtitle('r = 0.25\n') +
  scale_x_continuous(breaks = seq(0, 10, 5), limits = c(0, 10)) +
  scale_y_continuous(breaks = seq(-40, 40, 40), limits = c(-40, 40))


ggsave(file = 'pearson_3.png', type = 'cairo-png')
