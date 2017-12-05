import numpy as np
import sys
import os
import math
import keras
from keras.callbacks import LearningRateScheduler
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers.normalization import BatchNormalization
from keras.models import Sequential
from keras.utils.np_utils import to_categorical as cg
from keras.preprocessing.image import ImageDataGenerator


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
t['data'] = np.reshape(t['data'], (10000, 32, 32, 3), order='F')

concatenateX = []
concatenateY = []
for i in unpickledData:
    i['data'] = np.reshape(i['data'], (10000, 32, 32, 3), order='F')
    concatenateX.append(i['data'])
    concatenateY.append(cg(i['labels'], num_classes))

concatenateX = tuple(concatenateX)
concatenateY = tuple(concatenateY)

# print concatenateX, concatenateY
# print np.shape(concatenateX), np.shape(concatenateY)

x_train = np.concatenate(concatenateX, axis=0)
y_train = np.concatenate(concatenateY, axis=0)

x_test = t['data']
scam_data = unpickledData[1]['data']
scam_lab = cg(unpickledData[1]['labels'], num_classes)
# y_test = cg(t['labels'], num_classes)

np.random.seed(10)

batch_size = 128
num_classes = 10
epochs = 50


model = Sequential()

def addLayers(model, conv, norm, act, pool=None, drop=None):
    model.add(conv)
    model.add(norm)
    model.add(act)
    if pool:
        model.add(pool)
    if drop:
        model.add(drop)


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
    Dropout(0.1)
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
    Dropout(0.1)
)


model.add(Flatten())

addLayers(
    model,
    Dense(512),
    BatchNormalization(),
    Activation('relu'),
    None,
    Dropout(0.3)
)

model.add(Dense(num_classes))
model.add(BatchNormalization())
model.add(Activation('softmax'))

opt = keras.optimizers.Adam(lr=0.001)

model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

datagen = ImageDataGenerator(
        featurewise_center=False,
        samplewise_center=False,
        featurewise_std_normalization=False,
        samplewise_std_normalization=False,
        zca_whitening=False,
        rotation_range=5,
        width_shift_range=0.1,
        height_shift_range=0.1,
        horizontal_flip=True,
        vertical_flip=True)


x_train = (x_train.astype('float32') - 80) / 255
x_test = (x_test.astype('float32') - 80) / 255



datagen.fit(x_train)

def step_decay(epoch):
    initial_lrate = 0.001
    drop = 0.8
    epochs_drop = 10.0
    power = math.floor((1+epoch)/epochs_drop)
    lrate = initial_lrate * math.pow(drop, power)
    lrate = 0.0001 if (lrate < 0.0001) else lrate

    return lrate

lrate = LearningRateScheduler(step_decay)
callbacks_list = [lrate]

model.fit_generator(datagen.flow(x_train, y_train, batch_size=batch_size, shuffle=True),
          steps_per_epoch=x_train.shape[0] // batch_size,
          verbose=1,
          epochs=epochs,
          callbacks=callbacks_list,
          validation_data=(x_test, scam_lab),
          workers=4)


preds = model.predict(x_test)

with open('q2_b_output.txt', 'w') as f:
    for pred in preds:
        ind = np.argmax(pred)
        f.write(label_names[ind] + '\n')
