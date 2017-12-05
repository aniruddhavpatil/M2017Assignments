from sklearn.metrics import accuracy_score
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
import PIL.Image
import matplotlib.pyplot as plt
from random import randint
import numpy as np
import sys
from numpy import genfromtxt

clf = LogisticRegression(penalty='l2', C=0.001)
scaler = StandardScaler()

X_train = genfromtxt(sys.argv[1] + 'notMNIST_train_data.csv', delimiter=',')
X_test = genfromtxt(sys.argv[1] + 'notMNIST_test_data.csv', delimiter=',')

y_train = genfromtxt(sys.argv[1] + 'notMNIST_train_labels.csv', delimiter=',')
y_test = genfromtxt(sys.argv[1] + 'notMNIST_test_labels.csv', delimiter=',')

X_train = X_train.astype(float)
X_test = X_test.astype(float)

y_train = y_train.astype(float)
y_test = y_test.astype(float)

scaler.fit(X_train)
scaler.fit(X_test)

clf.fit(X_train, y_train)

test_preds = clf.predict(X_test)

W = clf.coef_
bias = clf.intercept_

for i,val in enumerate(test_preds):
	if val >= 0.5:
		test_preds[i] = 1
	else:
		test_preds[i] = 0

for i in test_preds:
	print int(i)

print accuracy_score(y_test, test_preds)


W = ((W - np.mean(W)) / (np.max(W) - np.min(W)))

W = (W + 1)/2

im = W.reshape((28, 28))

plt.imshow(im)
plt.show()
