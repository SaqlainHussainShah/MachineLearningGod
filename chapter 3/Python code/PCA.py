import numpy as np
import matplotlib.pyplot as plt
from sklearn import preprocessing

# data in 2-dimensional space
x = np.arange(1, 11, 1)
y = 1 + (x * 2) + (np.random.normal(0, 1, len(x)) * 5)
data_mat = np.column_stack((x,y))

# PCA
data_scaled = preprocessing.scale(data_mat)
w, v = np.linalg.eig(np.cov(data_scaled, rowvar=False))
pca_main_axis = v[:,0]
projected_data = np.dot(data_scaled, pca_main_axis)

# plot original data and PCA line
c0 = 0
c1 = pca_main_axis[1] / pca_main_axis[0]
yf = lambda x: c0 + c1*x
pca_y = list(map(yf, data_scaled[:,0]))

my_dpi = 96
plt.figure(figsize=(800/my_dpi, 800/my_dpi), dpi=my_dpi)

plt.scatter(data_scaled[:,0],data_scaled[:,1], color='b', s=20)
plt.plot(data_scaled[:,0],pca_y, color='r', linewidth=3)

plt.xlabel('X')
plt.ylabel('Y')
plt.title('Original Variables X and Y\n')

plt.savefig("pca_1.png")



# plot new variable
xx = projected_data
yy = np.zeros((len(projected_data)))

plt.figure(figsize=(800/my_dpi, 800/my_dpi), dpi=my_dpi)

plt.scatter(xx,yy, color='b', s=20)

plt.xlabel('Z')
plt.title('New Variable Z\n')

plt.savefig("pca_2.png")
