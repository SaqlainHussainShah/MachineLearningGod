library(Cairo)
library(ggplot2)

# c: vector of two coefficients c0 and c1,
# x: one-dimensional input vector,
# y: output class vector.
LogLikelihood <- function(c, x, y) {
  p <- 1 / (1 + exp(-(c[1] + c[2] * x)))
  log_likelihood <- sum(log(p[y == 1])) + sum(log(1 - p[y == 0]))
  return(-log_likelihood) # minus ll because we minimize in R
}

# sigmoid function.
Sig <- function(x, c) {
  return(1 / (1 + exp(-(c[1] + c[2] * x))))
}

# training data.
x_class_0 <- rnorm(50) - 1
x_class_1 <- rnorm(50) + 1
x <- c(x_class_0, x_class_1)

y_class_0 <- rep(0, 50)
y_class_1 <- rep(1, 50)
y <- c(y_class_0, y_class_1)

# MLE.
start_params <- c(1, 1)
optim_log_regression = optim(
  start_params,
  LogLikelihood,
  x = x,
  y = y,
  method = 'BFGS'
)

# compare to R method.
log_regression_R = glm(y ~ x,
                       data = data.frame(cbind(x, y)),
                       family = binomial)
print(data.frame(
  cbind(optim_log_regression$par, log_regression_R$coefficients)
))

# test data and predictions.
x_test <- rnorm(30) * 2
y_test <- rep(0, 30)
predictions <- Sig(x_test, optim_log_regression$par)

# plot train data.
Cairo(600,
      600,
      file = "train_data.png",
      type = "png",
      bg = "white")

y_zero <- rep(0, 100)
ggplot(data.frame(cbind(x, y_zero)), aes(x = x, y = y_zero)) +
  geom_point(size = 5, col = ifelse(y == 1, "red", "blue")) +
  theme_bw() +
  theme(
    text = element_text(size = 30),
    axis.text = element_text(size = 30),
    plot.title = element_text(hjust = 0.5, size = 30)
  ) +
  xlab('\nx') +
  ylab(' ') +
  ggtitle('Training data\n') +
  scale_x_continuous(breaks = seq(-5, 5, 5), limits = c(-5, 5)) +
  scale_y_continuous(breaks = seq(0, 1, 0.5), limits = c(0, 1))

dev.off()

# plot predictions.
sig2_c1 <- optim_log_regression$par[1]
sig2_c2 <- optim_log_regression$par[2]
Sig2 <- function(x) {
  return(1 / (1 + exp(-(
    sig2_c1 + sig2_c2 * x
  ))))
}

sig_x_intercept = -(sig2_c1 / sig2_c2) # analyitical inverse of sig

Cairo(600,
      600,
      file = "predictions.png",
      type = "png",
      bg = "white")

ggplot(data.frame(cbind(x_test, y_test)), aes(x = x_test, y = y_test)) +
  geom_point(size = 5,
             col = ifelse(predictions > 0.5, "red", "blue")) +
  theme_bw() +
  theme(
    text = element_text(size = 30),
    axis.text = element_text(size = 30),
    plot.title = element_text(hjust = 0.5, size = 30)
  ) +
  xlab('\nx') +
  ylab('p\n') +
  ggtitle('Classification of test data\n') +
  scale_x_continuous(breaks = seq(-5, 5, 5), limits = c(-5, 5)) +
  scale_y_continuous(breaks = seq(0, 1, 0.5), limits = c(0, 1)) +
  stat_function(fun = Sig2, col = 'green') +
  geom_vline(xintercept = sig_x_intercept, col = 'tan1')

dev.off()
