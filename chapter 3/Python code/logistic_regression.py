import numpy as np
from scipy.optimize import minimize
import matplotlib.pyplot as plt

# c: vector of two coefficients c0 and c1,
# x: one-dimensional input vector,
# y: output class vector.
def log_likelihood(c, x, y):
    p = 1 / (1 + np.exp(-(c[0] + c[1] * x)))
    ll = np.sum(np.log(p[y==1])) + np.sum(np.log(1 - p[y==0]))
    return -ll # minus ll because we will minimize

# sigmoid function.
def sig(x, c):
    return 1 / (1 + np.exp(-(c[0] + c[1]*x)))

# training data.
x_class_0 = np.random.normal(0, 1, 50) - 1
x_class_1 = np.random.normal(0, 1, 50) + 1
x = np.concatenate([x_class_0, x_class_1])

y_class_0 = np.zeros((50))
y_class_1 = np.ones((50))
y = np.concatenate([y_class_0, y_class_1])

yy = np.zeros((100))

colors = ['r', 'b']
f = lambda x: colors[int(x)]
colors1 = list(map(f, y))

# MLE.
start_params = np.array([1, 1])
res = minimize(log_likelihood, start_params, args=(x,y), method='BFGS', options={'gtol': 1e-6, 'disp': False})

# test data and predictions.
x_test = np.random.normal(0, 1, 30) * 2
y_test = np.zeros((30))
predictions = sig(x_test, res.x)

f2 = lambda x: int(x > 0.5)
predictions = list(map(f2, predictions))

c0 = res.x[0]
c1 = res.x[1]

colors2 = list(map(f, predictions))

# plot train data.
my_dpi = 96
plt.figure(figsize=(800/my_dpi, 800/my_dpi), dpi=my_dpi)

plt.xlabel('X')
plt.title('Training Data\n')

plt.scatter(x, yy, color=colors1)

plt.savefig("C:/Users/Stefan/Desktop/log_regression_train.png")

# plot predictions.
def sig2(x):
    return 1 / (1 + np.exp(-(c0 + c1 * x)))

sig_x_intercept = -(c0 / c1) # analyitical inverse of sig

sigx = np.arange(-5, 5, 0.1)
sigy = list(map(sig2, sigx))

my_dpi = 96
plt.figure(figsize=(800/my_dpi, 800/my_dpi), dpi=my_dpi)

plt.xlabel('X')
plt.ylabel('P')
plt.title('Classification of Test Data\n')

plt.scatter(x_test, y_test, color=colors2)
plt.plot(sigx, sigy)
plt.plot([sig_x_intercept, 0], [sig_x_intercept, 1])

plt.savefig("C:/Users/Stefan/Desktop/log_regression_test.png")