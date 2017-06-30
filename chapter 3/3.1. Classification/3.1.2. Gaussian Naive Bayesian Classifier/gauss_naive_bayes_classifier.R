library(ggplot2)
library(Cairo)

# generate and plot training data

x_class_1 <- seq(2, 6, 0.2)
y_class_1 <- 1 + rnorm(length(x_class_1)) * 2

x_class_2 <- seq(14, 18, 0.2)
y_class_2 <- 1 + rnorm(length(x_class_2)) * 2

x_class_3 <- seq(7, 12, 0.2)
y_class_3 <- 14 + rnorm(length(x_class_3)) * 2

x <- c(x_class_1, x_class_2, x_class_3)
y <- c(y_class_1, y_class_2, y_class_3)

classes <- c(rep(1, length(x_class_1)), rep(2, length(x_class_2)), rep(3, length(x_class_3)))

train_data <- cbind(x, y, classes)
J <- 2

palette(rainbow(3))

CairoWin()

ggplot(data.frame(x, y), aes(x = x, y = y)) +
  geom_point(pch = c(14 + classes), size = c(rep(4, nrow(train_data))), col = c(classes)) +
  xlab('\nx1') +
  ylab('x2\n') +
  theme_bw() +
  theme(
    text = element_text(size = 25),
    axis.text = element_text(size = 25),
    plot.title = element_text(hjust = 0.5, size = 25)
  ) +
  ggtitle('Training data\n') +
  scale_x_continuous(breaks = seq(0, 20, 10), limits = c(0, 20)) +
  scale_y_continuous(breaks = seq(-10, 20, 10), limits = c(-10, 20))

ggsave(file = 'naive_bayes_train_data.png', type = 'cairo-png')

# learn a Gaussian Naive Bayesian Classifier

# prior P(Y)
prior <- function(data, K) {
  p <- rep(1, K)
  for(k in 1:K) {
    p[k] <- sum(data[, ncol(data)] == k) / nrow(data)
  }
  return(p)
}
prior <- prior(train_data, 3)

# learn J*K Gaussian components of the likelihood P(X|Y)
learn_gaussians <- function(train_data, J, K) {
  mean <- matrix(nrow = J, ncol = K)
  variance <- matrix(nrow = J, ncol = K)
  classes <- train_data[, ncol(train_data)]
  for(j in 1:J) {
    for(k in 1:K) {
      mean[j, k] <- sum(train_data[classes == k, j]) / sum(classes == k)
      variance[j, k] <- sum((train_data[classes == k, j] - mean[j, k])^2) / (sum(classes == k) - 1)
    }
  }
  return(list(mean, variance))
}
gaussians <- learn_gaussians(train_data, 2, 3)
gauss_mean <- gaussians[[1]]
gauss_variance <- gaussians[[2]]

# likelihood function for one data point xi, P(xi|Y=k)
likelihood <- function(xi, k, gauss_mean, gauss_variance) {
  product_of_gaussians <- 1
  for(j in 1:J) {
    gaussian_ <- dnorm(xi[j], gauss_mean[j, k], sqrt(gauss_variance[j, k]))
    product_of_gaussians <- product_of_gaussians * gaussian_
  }
  return(product_of_gaussians)
}

# compute posterior P(Y|xi) for one data point xi, for each class k
posterior <- function(xi, K, gauss_mean, gauss_variance) {
  post <- rep(0, K)
  for(k in 1:K) {
    post[k] <- prior[k] * likelihood(xi, k, gauss_mean, gauss_variance)
  }
  return(post)
}

# generate test data
x_test <- seq(0, 20, 0.2)
y_test <- 3 + rnorm(length(x_test)) * 12
data_test <- cbind(x_test, y_test)

# classify with Naive Bayes
classes_test <- rep(1, length(x_test))
for(i in 1:nrow(data_test)) {
  classes_test[i] <- which.max(posterior(data_test[i, ], 3, gauss_mean, gauss_variance))
}

CairoWin()

ggplot(data.frame(x_test, y_test), aes(x = x_test, y = y_test)) +
  geom_point(pch = c(14 + classes_test), size = c(rep(4, length(x_test))), col = c(classes_test)) +
  xlab('\nx1') +
  ylab('x2\n') +
  theme_bw() +
  theme(
    text = element_text(size = 25),
    axis.text = element_text(size = 25),
    plot.title = element_text(hjust = 0.5, size = 25)
  ) +
  ggtitle('Test data\n') +
  scale_x_continuous(breaks = seq(0, 20, 10), limits = c(0, 20)) +
  scale_y_continuous(breaks = seq(-10, 20, 10), limits = c(-10, 20))

ggsave(file = 'naive_bayes_test_data.png', type = 'cairo-png')
