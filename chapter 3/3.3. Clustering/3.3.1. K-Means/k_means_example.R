library(ggplot2)
library(Cairo)

source('k_means.R')

x_cluster_1 <- seq(2, 6, 0.2)
y_cluster_1 <- 1 + rnorm(length(x_cluster_1)) * 2

x_cluster_2 <- seq(14, 18, 0.2)
y_cluster_2 <- 1 + rnorm(length(x_cluster_2)) * 2

x_cluster_3 <- seq(7, 12, 0.2)
y_cluster_3 <- 14 + rnorm(length(x_cluster_3)) * 2

x <- c(x_cluster_1, x_cluster_2, x_cluster_3)
y <- c(y_cluster_1, y_cluster_2, y_cluster_3)

data <- data.frame(x, y)
data_matrix <- cbind(x, y)

CairoWin()

ggplot(data, aes(x = x, y = y)) +
  geom_point(size = 4) +
  xlab('\nx1') +
  ylab('x2\n') +
  theme_bw() +
  theme(
    text = element_text(size = 25),
    axis.text = element_text(size = 25),
    plot.title = element_text(hjust = 0.5, size = 25)
  ) +
  ggtitle('Input data\n') +
  scale_x_continuous(breaks = seq(0, 20, 10), limits = c(0, 20)) +
  scale_y_continuous(breaks = seq(-10, 20, 10), limits = c(-10, 20))

ggsave(file = 'k_means_input.png', type = 'cairo-png')

K <- 3
k_means_result <- k_means(data_matrix, K)
centroids <- data.frame(k_means_result[[1]])
cluster_assignments <- k_means_result[[2]]

data2 <- rbind(data_matrix, centroids)

palette(rainbow(K))

CairoWin()

ggplot(data.frame(data2), aes(x = x, y = y)) +
  geom_point(pch = c(14 + cluster_assignments, rep(1, K)), size = c(rep(4, nrow(data_matrix)), rep(70, K)), col = c(cluster_assignments, rep('darkmagenta', K))) +
  xlab('\nx1') +
  ylab('x2\n') +
  theme_bw() +
  theme(
    text = element_text(size = 25),
    axis.text = element_text(size = 25),
    plot.title = element_text(hjust = 0.5, size = 25)
  ) +
  ggtitle('K-Means clustering\n') +
  scale_x_continuous(breaks = seq(0, 20, 10), limits = c(0, 20)) +
  scale_y_continuous(breaks = seq(-10, 20, 10), limits = c(-10, 20))

ggsave(file = 'k_means_result.png', type = 'cairo-png')