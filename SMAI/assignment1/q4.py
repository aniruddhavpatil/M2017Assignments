#!/usr/bin/env python

import sys
import os
import numpy as np
import pickle
from copy import *
"""Feel free to add any extra classes/functions etc as and when needed.
This code is provided purely as a starting point to give you a fair idea
of how to go about implementing machine learning algorithms in general as
a part of the first assignment. Understand the code well"""

D = {}
classes = ['galsworthy/','galsworthy_2/','mill/','shelley/','thackerey/','thackerey_2/','wordsmith_prose/','cia/','johnfranklinjameson/','diplomaticcorr/']


def safeKeep(obj,filename):
	with open(filename, 'wb') as op:
		pickle.dump(obj,op,pickle.HIGHEST_PROTOCOL)

def safeLoad(filename):
	return pickle.load(open(filename, 'rb'))

class FeatureVector(object):
	def __init__(self,vocabsize,numdata):
		self.vocabsize = vocabsize
		self.X =  np.zeros((numdata,self.vocabsize), dtype=np.int)
		self.Y =  np.zeros((numdata,), dtype=np.int)
		self.i=0

	def make_featurevector(self, input, classid):
		self.Y[self.i] = classid
		self.X[self.i] = deepcopy(input)
		self.i+=1

class KNN(object):
	def __init__(self,trainVec,testVec):
		self.X_train = trainVec.X
		self.Y_train = trainVec.Y
		self.X_test = testVec.X
		self.Y_test = testVec.Y
		self.correct = 0

	def countOccur(self, ans):
		a = [0 for i in range(len(classes) + 1)]
		for i,val in enumerate(ans):
			a[val]+=1

		Max = 0
		Max_i = 1
		for i,val in enumerate(a):
			if val > Max:
				Max = val
				Max_i = i

		return Max_i




	def classify(self, nn = 1):
		ans = [0 for i in range(nn)]
		correct = 0
		for j,yVec in enumerate(self.X_test):
			d = []
			for i,xVec in enumerate(self.X_train):
				denom = (np.linalg.norm(xVec)*np.linalg.norm(yVec))
				denom = 1 if denom == 0 else denom
				dist = 1 - np.dot(xVec,yVec)/denom
				d.append((dist,i))
			d.sort()
			# print d[:nn]
			d = d[:nn]
			for i,item in enumerate(d):
				ans[i] = self.Y_train[int(item[1])]
			# print ans
			label = self.countOccur(ans)
			# print label,self.Y_test[j]
			label = classes[label-1]
			label = label.strip('/')
			print label			


if __name__ == '__main__':

	inputdir = [sys.argv[1],sys.argv[2]]

	vocab = 0
	trainsz = 0
	testsz = 0
	iterD = 0
	for idir in inputdir:
		classid = 1
		for c in classes:
			listing = os.listdir(idir+c)
			for filename in listing:
				if idir == sys.argv[1]:
					trainsz+=1
					with open(idir+c+filename,'r') as f:
						# print filename
						for line in f:
							line = line.strip('\n')
							line = line.split()[1:-1]
							for word in line:
								if word.isalpha() and len(word) > 3:
									if word not in D:
										D[word] = iterD
										iterD+=1
				else:
					testsz+=1
			classid += 1
	#
	# D = list(lset)
	# D = [x for x in D if x.isalpha()]
	# D = [x for x in D if len(x) > 3]
	# vocab = len(D)
	# print D
	# print len(D), trainsz,testsz
	# safeKeep(D,'D.pkl')
	# safeKeep(testsz,'testsz.pkl')
	# safeKeep(trainsz, 'trainsz.pkl')

	# D = safeLoad('D.pkl')
	vocab = len(D)
	# trainsz = safeLoad('trainsz.pkl')
	# testsz = safeLoad('testsz.pkl')
	# print trainsz,testsz
	# print('Making the feature vectors.')
	trainVec = FeatureVector(vocab,trainsz)
	testVec = FeatureVector(vocab,testsz)
	#
	for idir in inputdir:
		classid = 1
		for c in classes:
			listing = os.listdir(idir+c)
			for filename in listing:
				with open(idir+c+filename,'r') as f:
					inputs = np.zeros(vocab)
					for line in f:
						line = line.strip('\n')
						line = line.split()[1:-1]
						for word in line:
							if word.isalpha() and len(word) > 3:
								if word in D:
									inputs[D[word]]+=1
					# print idir+c+filename
					if idir == sys.argv[1]:
						trainVec.make_featurevector(inputs,classid)
						pass
					else:
						testVec.make_featurevector(inputs,classid)
						pass
			classid += 1

	# safeKeep(testVec.X,'testVec.pkl')
	# safeKeep(testVec.Y,'testVecLabel.pkl')
	#
	# safeKeep(trainVec.X,'trainVec.pkl')
	# safeKeep(trainVec.Y,'trainVecLabel.pkl')

	# testVec.X = safeLoad('testVec.pkl')
	# testVec.Y = safeLoad('testVecLabel.pkl')
	#
	# trainVec.X = safeLoad('trainVec.pkl')
	# trainVec.Y = safeLoad('trainVecLabel.pkl')

	# print('Finished making features.')
	# print('Statistics ->')
	# print(trainVec.X.shape,trainVec.Y.shape,testVec.X.shape,testVec.Y.shape)
	#
	knn = KNN(trainVec,testVec)
	knn.classify(5)
	knn.classify(11)
	knn.classify(17)
