import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np

model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(5, 3)),
  tf.keras.layers.Dense(10, activation="relu"),
  tf.keras.layers.Dropout(0.2),
  tf.keras.layers.Dense(10),
])

def model_predict(x, plot=True):
    if plot:
        plt.figure(figsize=(1.5,1.5))
        plt.imshow(x)
        plt.show()
    x = x.reshape((-1,5,3))
    predictions = model(x)
    print(np.argmax(predictions), predictions.numpy())
