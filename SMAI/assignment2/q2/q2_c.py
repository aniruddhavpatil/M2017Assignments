import numpy as np
import sys
import os
import copy
import keras
from sklearn import svm
from keras.preprocessing.image import ImageDataGenerator
from keras.utils.np_utils import to_categorical as cg
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers.normalization import BatchNormalization
from keras.models import Sequential
from keras.datasets import cifar10

num_classes = 10

def unpickle(file):
    import cPickle
    with open(file, 'rb') as fo:
        dict = cPickle.load(fo)
    return dict

path = sys.argv[1]
testpath = sys.argv[2]

metadata = unpickle(os.path.join(path, "batches.meta"))
label_names = metadata["label_names"]

batches = ["data_batch_1", "data_batch_2", "data_batch_3", "data_batch_4", "data_batch_5"]

unpickledData = []

for i in batches:
    unpickledData.append(unpickle(os.path.join(path, i)))

t = unpickle(testpath)

concatenateX = []
concatenateY = []
tempY = []
for i in unpickledData:
    i['data'] = np.reshape(i['data'], (10000, 32, 32, 3), order='F')
    concatenateX.append(i['data'])
    tempY.append(i['labels'])
    concatenateY.append(cg(i['labels'], num_classes))

concatenateX = tuple(concatenateX)
concatenateY = tuple(concatenateY)
tempY = tuple(tempY)

t['data'] = np.reshape(t['data'], (10000, 32, 32, 3))


x_train = np.concatenate(concatenateX, axis=0)
y_train = np.concatenate(concatenateY, axis= 0)

x_test = t['data']
# y_test = cg(t['labels'], num_classes)
y_test = cg(unpickledData[1]['labels'], num_classes)

tempy_train = np.concatenate(tempY, axis=0)
tempy_test = unpickledData[1]['labels']

np.random.seed(1000)

batch_size = 128
num_classes = 10
epochs = 5

model = Sequential()

def addLayers(model, conv, norm, act, pool=None, drop=None):
    model.add(conv)
    model.add(norm)
    model.add(act)
    if pool:
        model.add(pool)
    if drop:
        model.add(drop)

def pop_layer(model):
    if not model.outputs:
        raise Exception('Model is empty.')

    model.layers.pop()
    if not model.layers:
        model.outputs = []
        model.inbound_nodes = []
        model.outbound_nodes = []
    else:
        model.layers[-1].outbound_nodes = []
        model.outputs = [model.layers[-1].output]
    model.built = False

addLayers(
    model,
    Conv2D(32, (3, 3), padding='same', input_shape=x_train.shape[1:]),
    BatchNormalization(),
    Activation('relu')
)

addLayers(
    model,
    Conv2D(32, (3, 3)),
    BatchNormalization(),
    Activation('relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Dropout(0.25)
)

addLayers(
    model,
    Conv2D(64, (3, 3), padding='same'),
    BatchNormalization(),
    Activation('relu'),
)

addLayers(
    model,
    Conv2D(64, (3, 3)),
    BatchNormalization(),
    Activation('relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Dropout(0.25)
)

model.add(Flatten())

addLayers(
    model,
    Dense(512),
    BatchNormalization(),
    Activation('relu'),
    None,
    Dropout(0.5),
)

addLayers(
    model,
    Dense(num_classes),
    BatchNormalization(),
    Activation('softmax')
)

opt = keras.optimizers.SGD(lr=0.1, decay=1e-6, momentum=0.9, nesterov=True)

model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

datagen = ImageDataGenerator(
        featurewise_center=False,
        samplewise_center=False,
        featurewise_std_normalization=False,
        samplewise_std_normalization=False,
        zca_whitening=False,
        rotation_range=0,
        width_shift_range=0.1,
        height_shift_range=0.1,
        horizontal_flip=True,
        vertical_flip=False)

x_train = (x_train.astype('float32') - 100) / 255
x_test = (x_test.astype('float32') - 100) / 255

datagen.fit(x_train)

model.fit_generator(datagen.flow(x_train, y_train, batch_size=batch_size, shuffle=True),
          steps_per_epoch=x_train.shape[0] // batch_size,
          epochs=epochs,
          validation_data=(x_test, y_test),
          workers=4, verbose=0)


for _ in range(5):
    pop_layer(model)

model.build()

clf = svm.LinearSVC(verbose=0, max_iter=1000, multi_class='ovr')

inp_train = model.predict(x_train)
inp_test = model.predict(x_test)

clf.fit(inp_train, tempy_train)

# for pred in clf.predict(inp_test):
#     print label_names[pred]

with open('q2_c_output.txt', 'w') as f:
    for pred in clf.predict(inp_test):
        ind = np.argmax(pred)
        f.write(label_names[ind] + '\n')
