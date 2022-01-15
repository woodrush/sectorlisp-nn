import tensorflow as tf
import numpy as np

from dataset import dataset
from model import model, model_predict

if __name__ == "__main__":
    data_x, data_y_labelname = zip(*dataset)
    data_x = np.array(data_x, dtype=np.float64)
    data_y_category = np.array(data_y_labelname, dtype=np.float64)
    data_y = np.zeros((data_x.shape[0], 10), dtype=np.float64)
    for i, y in enumerate(data_y_labelname):
        data_y[i,y] = 1

    model.compile(optimizer="adam",
                loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
                metrics=["accuracy"])

    model.fit(data_x, data_y_category, epochs=1000, verbose=0)

    for x, y in zip(data_x, data_y_labelname):
        print(y)
        model_predict(x, plot=False)

    model_predict(np.array([
        [0,1,1],
        [0,0,1],
        [0,1,1],
        [0,1,0],
        [1,0,0]
    ], dtype=np.float64), plot=False)

    model_predict(np.array([
        [1,0,0],
        [1,0,1],
        [1,0,0],
        [0,0,0],
        [1,0,0]
    ], dtype=np.float64), plot=False)

    model.evaluate(data_x, data_y_category, verbose=2)

    model.save("params.h5")
