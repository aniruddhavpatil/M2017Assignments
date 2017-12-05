import numpy as np
import sys
# import os

train_data = np.genfromtxt(sys.argv[1], delimiter=',')
test_data = np.genfromtxt(sys.argv[2], delimiter=',')
# train_data = []
# test_data = []
# W(k+1) = W(K) + X(K)
# W(k+1) = W(K) - X(K)
# print len(dataset)

def initWeight(dataset):
    dimension = len(dataset[0]) - 1
    W = [1 for i in range(dimension)]
    W = np.asmatrix(W)
    return W

class SimplePerceptron(object):
    def __init__(self):
        self.W = []

    def train(self,dataset,epoch):
        dimension = len(dataset[0]) - 1
        self.W = [1 for i in range(dimension)]
        self.W = np.asmatrix(self.W)
        W = self.W
        for i in range(epoch):
            for vector in dataset:
                # vector = dataset[0]
                label = vector[0]
                # print label
                X = vector[1:]
                # X = np.asmatrix(X)
                WX = np.dot(W,X)/np.linalg.norm(W)
                # WX = (W * X.transpose()).item(0)/np.linalg.norm(W)
                # print WX
                if label == 1 and WX < 0:
                    W = W + X
                elif label == 0 and WX > 0:
                    W = W - X
            self.W = W
        return W

class SimplePerceptronMargin(object):
    def __init__(self,gamma):
        self.W = []
        self.gamma = gamma

    def train(self, dataset, epoch):
        dimension = len(dataset[0]) - 1
        self.W = [1 for i in range(dimension)]
        self.W = np.asmatrix(self.W)
        W = self.W
        for i in range(epoch):
            for vector in dataset:
                # vector = dataset[0]
                label = vector[0]
                # print label
                X = vector[1:]
                # X = np.asmatrix(X)
                # WX = (W * X.transpose()).item(0)/np.linalg.norm(W)
                WX = np.dot(W,X)/np.linalg.norm(W)
                # print WX
                if label == 1 and WX <= -self.gamma/2:
                    W = W + X
                elif label == 0 and WX > self.gamma/2:
                    W = W - X
            self.W = W
        return W


class BatchPerceptron(object):
    def __init__(self):
        self.W = []

    def train(self,dataset,epoch):
        dimension = len(dataset[0]) - 1
        self.W = [1 for i in range(dimension)]
        self.W = np.asmatrix(self.W)
        W = self.W
        delta = 0
        for i in range(epoch):
            for vector in dataset:
                # vector = dataset[0]
                label = vector[0]
                # print label
                X = vector[1:]
                # X = np.asmatrix(X)
                WX = np.dot(W,X)/np.linalg.norm(W)
                # WX = (W * X.transpose()).item(0)/np.linalg.norm(W)
                # print WX
                if label == 1 and WX < 0:
                    delta = delta + X
                elif label == 0 and WX > 0:
                    delta = delta - X
            W = W + delta
            self.W = W
        return W

class BatchPerceptronMargin(object):
    def __init__(self,gamma):
        self.W = []
        self.gamma = gamma
    def train(self,dataset,epoch):
        dimension = len(dataset[0]) - 1
        self.W = [1 for i in range(dimension)]
        self.W = np.asmatrix(self.W)
        W = self.W
        delta = 0
        for i in range(epoch):
            for vector in dataset:
                # vector = dataset[0]
                label = vector[0]
                # print label
                X = vector[1:]
                # X = np.asmatrix(X)
                WX = np.dot(W,X)/np.linalg.norm(W)
                # WX = (W * X.transpose()).item(0)/np.linalg.norm(W)
                # print WX
                if label == 1 and WX <= -self.gamma/2:
                    delta = delta + X
                elif label == 0 and WX > self.gamma/2:
                    delta = delta - X
            W = W + delta
            self.W = W
        return W

def test(dataset, W):
    precision = 0
    recall = 0
    wrong = 0
    total = len(test_data)
    for vector in dataset:
        # vector = dataset[0]
        # label = vector[0]
        # print label
        X = vector[:]
        X = np.asmatrix(X)
        WX = (W * X.transpose()).item(0)
        # print WX
        if WX < 0:
            print 0
        elif WX > 0:
            print 1
    #
    # precision= (1 - float(wrong)/total) * 100
    # return [wrong,recall]


W = initWeight(train_data)

# for i in range(11):
#     W = trainSingle(train_data, W)
#     ans = test(train_data, W)
#     if ans[0] == 0:
#         print i
#         break

# for i in range(13):
#     W = trainSingleMargin(train_data, W, 10)
#     ans = test(train_data, W)
#     print ans
#     if ans[0] == 0:
#         print i
#         break

simple = SimplePerceptron()
wNoMargin = simple.train(train_data,40)
test(test_data,wNoMargin)

simpleMargin = SimplePerceptronMargin(10)
wMargin = simpleMargin.train(train_data,40)
test(test_data,wMargin)

batch = BatchPerceptron()
wBatchTrain = batch.train(train_data,40)
test(test_data, wBatchTrain)

batchMargin = BatchPerceptronMargin(10)
wBatchMarginTrain = batchMargin.train(train_data,40)
test(test_data, wBatchMarginTrain)
