import numpy as np
import sys
from copy import *

train_data_temp = np.genfromtxt(sys.argv[1], delimiter=',')
test_data_temp = np.genfromtxt(sys.argv[2], delimiter=',')
train_data = []
test_data = []
gamma =10

for i in test_data_temp:
    i[0] = i[len(i) -1]
    i = i[0 : len(i) -1]
    test_data.append(i)

for i in train_data_temp:
    i[0] = i[len(i) -1]
    i = i[0 : len(i) -1]
    train_data.append(i)

train_data = np.asarray(train_data)
test_data = np.asarray(test_data)

# print test_data

# for i in train_data_temp:
#     i[0] = i[len(i) -1]
#     i = i[0 : len(i) -1]
#     print i

def initWeight(dataset):
    dimension = len(dataset[0]) - 1
    W = [1 for i in range(dimension)]
    W = np.asmatrix(W)
    return W


class SimplePerceptronMargin(object):
    def __init__(self,gamma,eta):
        self.W = []
        self.gamma = gamma
        self.eta = eta

    def train(self, dataset, epoch):
        dimension = len(dataset[0])
        self.W = [1 for i in range(dimension)]
        self.W = np.asmatrix(self.W)
        W = self.W
        for i in range(epoch):
            wrong = 0
            for j,vector in enumerate(dataset):
                temp = deepcopy(vector)
                label = temp[0]
                temp[0] = 1
                if label == 2:
                    temp = -temp
                X = temp[:]
                normX = np.linalg.norm(X)
                WX = np.dot(W,X)/normX
                if WX <= self.gamma:
                    delJ = (self.eta*(self.gamma - WX) / (normX*normX))*X
                    W = W + delJ
                    wrong+=1
            self.W = W
            # print wrong
        return W

class ModifiedPerceptronMargin(object):
    def __init__(self,gamma,eta):
        self.W = []
        self.gamma = gamma
        self.eta = eta

    def train(self, dataset, epoch):
        dimension = len(dataset[0])
        self.W = [1 for i in range(dimension)]
        self.W = np.asmatrix(self.W)
        W = self.W
        prevWrong=float("inf")
        for i in range(epoch):
            wrong = 0
            for j,vector in enumerate(dataset):
                temp = deepcopy(vector)
                label = vector[0]
                temp[0] = 1

                if label == 2:
                    temp = -temp
                X = temp[:]

                normX = np.linalg.norm(X)
                WX = np.dot(W,X)

                if WX <= self.gamma:
                    delJ = ((self.gamma - WX) / (normX*normX))*X
                    W = W + self.eta * delJ
                    wrong+=1
                # print 'label3', label
                # temp[0] = deepcopy(label)
                # vector = -vector
            if wrong < prevWrong:
                self.W = W
                prevWrong = wrong
                # print wrong, prevWrong
        return W



def test(dataset, W):
    precision = 0
    recall = 0
    wrong = 0
    total = len(test_data)
    for vector in dataset:
        temp = [0 for i in range(vector.size + 1)]
        temp[0] = 1
        temp[1:] = vector
        X = temp[:]
        # X = np.asmatrix(X)
        # print "vector", temp
        WX = np.dot(W,X)
        # print WX
        if WX <= 0:
            print 2
        else:
            print 4
    #
    # precision= (1 - float(wrong)/total) * 100
    # return [wrong,recall]


# W = initWeight(train_data)
simple = SimplePerceptronMargin(10,0.05)
W = simple.train(train_data,100)
test(test_data,W)

modded = ModifiedPerceptronMargin(10,0.05)
W = modded.train(train_data,100)
test(test_data,W)
