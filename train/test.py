import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import confusion_matrix
import seaborn as sns

from model import model, model_predict
from dataset import test_dataset

if __name__ == "__main__":
    data_x_test, data_y_labelname_test = zip(*test_dataset)
    data_x_test = np.array(data_x_test, dtype=np.float64)
    data_y_category_test = np.array(data_y_labelname_test, dtype=np.float64)
    data_y_test = np.zeros((data_x_test.shape[0], 10), dtype=np.float64)
    for i, y in enumerate(data_y_labelname_test):
        data_y_test[i,y] = 1
    
    model.compile(optimizer="adam",
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=["accuracy"])
    
    model.load_weights("./params.h5")

    model.evaluate(data_x_test, data_y_category_test, verbose=2)

    predlist = []
    for x, y in zip(data_x_test, data_y_labelname_test):
        print(y)
        pred = model_predict(x, plot=False)
        predlist.append(pred)
        # showimg(x)
    
    print(data_y_labelname_test)
    print(predlist)
    cmat = confusion_matrix(data_y_labelname_test, predlist)
    plt.figure(figsize=(10,8))
    sns.heatmap(cmat, annot=True)
    plt.xlabel("Prediction")
    plt.ylabel("Ground Truth")
    plt.title("Test dataset evaluation")
    plt.savefig("confusion_matrix.png")
    # plt.show()
    plt.close()
