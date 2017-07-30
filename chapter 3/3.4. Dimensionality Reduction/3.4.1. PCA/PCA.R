library(ggplot2)
library(Cairo)

# data in 2-dimensional space
x <- seq(1, 10, 1)
y <- 1 + 2 * x + rnorm(length(x)) * 5
data_mat <- cbind(x, y)

# PCA
data_scaled <- scale(data_mat, center = TRUE, scale = TRUE)
cov_mat_eig <- eigen(cov(data_scaled))
pca_main_axis <- matrix(cov_mat_eig$vectors[, 1])
projected_data <- data_scaled %*% pca_main_axis

# comparison to R's PCA
pca_r <- prcomp(data_mat, center = TRUE, scale = TRUE)
pca_main_axis_r <- pca_r$rotation[, 1]
projected_data_r <- pca_r$x[, 1]

all(round(abs(pca_main_axis), 3) == round(abs(pca_main_axis_r), 3))
all(round(abs(projected_data), 3) == round(abs(projected_data_r), 3))

# plot original data and PCA line
c0 <- 0
c1 <- pca_main_axis[2] / pca_main_axis[1]
yf <- function(x) {
  c0 + c1 * x
}

CairoWin()

ggplot(data.frame(data_scaled), aes(x = x, y = y, label = 1:10)) +
  geom_point(size = 4, col = 'blue') +
  geom_text(aes(label = 1:10), hjust = 2, vjust = 0, size = 7) +
  stat_function(
    fun = yf,
    geom = "line",
    col = 'red',
    size = 2
  ) +
  xlab('\nx') +
  ylab('y\n') +
  theme_bw() +
  theme(
    text = element_text(size = 25),
    axis.text = element_text(size = 25),
    plot.title = element_text(hjust = 0.5, size = 25)
  ) +
  ggtitle('Original variables x and y\n')

ggsave(file = 'original_data.png', type = 'cairo-png')

# plot new variable
xx <- projected_data
yy <- rep(0, length(projected_data))

CairoWin()

ggplot(data.frame(xx, yy), aes(x = xx, y = yy, label = 1:10)) +
  geom_point(size = 4, col = 'blue') +
  geom_text(aes(label = 1:10), hjust = 0, vjust = -2, size = 7) +
  xlab('\nz') +
  ylab('') +
  theme_bw() +
  theme(
    text = element_text(size = 25),
    axis.text = element_text(size = 25),
    plot.title = element_text(hjust = 0.5, size = 25)
  ) +
  ggtitle('New variable z\n') +
  scale_y_continuous(breaks = seq(-0.5, 0.5, 0.5),
                     limits = c(-0.5, 0.5))

ggsave(file = 'new_data.png', type = 'cairo-png')
