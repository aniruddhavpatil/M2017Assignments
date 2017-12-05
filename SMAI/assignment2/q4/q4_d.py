import sys
import numpy as np
from sklearn.metrics import mean_squared_error, r2_score
from sklearn import linear_model
from sklearn.linear_model import LinearRegression

regr = linear_model.LinearRegression()

trainData = np.loadtxt(sys.argv[1], delimiter = ',')
testData = np.loadtxt(sys.argv[2], delimiter = ',')

c1 = len(trainData)
c2 = len(testData)


trainX = np.zeros(shape=(c1, 11))
trainY = np.zeros(shape=(c1,1))
testX = np.zeros(shape=(c2, 11))
# testY = np.zeros(shape=(c2,1))

for i,line in enumerate(trainData):
	trainY[i][0] = line[-1:]
	trainX[i][:] = line[:-1]

for i,line in enumerate(testData):
	# testY[i][0] = line[-1:]
	testX[i][:] = line[:]

regr.fit(trainX, trainY)

y_pred = regr.predict(testX)

for i,val in enumerate(y_pred):
	if val < 0.5:
		y_pred[i] = 0
	elif val >= 0.5:
		y_pred[i] = 1

# correctLabels = 0
# for i,_ in enumerate(testY):
# 	if y_pred[i] == testY[i][0]:
# 		correctLabels += 1
# print correctLabels
#
# wrongLabels = c2 - correctLabels
# print wrongLabels, c2
# acc = (correctLabels/float(c2))
# print 'Accuracy', acc

for i in y_pred:
	print int(i)
