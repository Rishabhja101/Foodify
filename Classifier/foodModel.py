import cv2
import numpy as np
import os
import sys
import tensorflow as tf
from PIL import Image
import os.path as path

from sklearn.model_selection import train_test_split
from tensorflow.python.keras import regularizers

EPOCHS = 35
IMG_WIDTH = 40
IMG_HEIGHT = 40
NUM_CATEGORIES = 20
TEST_SIZE = 0.3


def main():
    # Check command-line arguments
    if len(sys.argv) not in [2, 3]:
        sys.exit("Usage: python traffic.py data_directory [model.h5]")

    # Get image arrays and labels for all image files
    images, labels = load_data(sys.argv[1])

    # Split data into training and testing sets
    labels = tf.keras.utils.to_categorical(labels)
    x_train, x_test, y_train, y_test = train_test_split(
        np.array(images), np.array(labels), test_size=TEST_SIZE
    )

    # Get a compiled neural network
    model = get_model()

    # Fit model on training data
    model.fit(x_train, y_train, epochs=EPOCHS)

    # Evaluate neural network performance
    model.evaluate(x_test, y_test, verbose=2)

    # Save model to file

    model.save('modelLoadCategorical.h5')


def load_data(data_dir):
    """
    Load image data from directory `data_dir`.

    Assume `data_dir` has one directory named after each category, numbered
    0 through NUM_CATEGORIES - 1. Inside each category directory will be some
    number of image files.

    Return tuple `(images, labels)`. `images` should be a list of all
    of the images in the data directory, where each image is formatted as a
    numpy ndarray with dimensions IMG_WIDTH x IMG_HEIGHT x 3. `labels` should
    be a list of integer labels, representing the categories for each of the
    corresponding `images`.
    """
    images = []
    labels = []

    for x in range(NUM_CATEGORIES):
        directory = os.path.join("WebScraper" ,"data", "0","images", str(x))
        count = 0

        #print(str(x) + ' ' + directory + ' ' + str(path.exists('/Users/rishabhja/Documents/GitHub/Foodify/' + directory)) + ' ' + str(path.exists('/Users/rishabhja/Documents/GitHub/Foodify/WebScraper/data/images/0')))
    

        if (path.exists('/Users/rishabhja/Documents/GitHub/Foodify/' + directory)):
            
            for file in os.listdir('/Users/rishabhja/Documents/GitHub/Foodify/' + directory):
                im = cv2.imread(os.path.join('/Users/rishabhja/Documents/GitHub/Foodify/', directory, file))
                if file[-1] == 'e':
                    continue

                # print(str(x) + ' ' + file)

                # im = np.array(Image.open(os.path.join(directory, file)))
                resized_image = cv2.resize(im, (IMG_HEIGHT, IMG_WIDTH))

                count += 1
                images.append(resized_image)
                labels.append(str(x))

    return images, labels


def get_model():
    """
    Returns a compiled convolutional neural network model. Assume that the
    `input_shape` of the first layer is `(IMG_WIDTH, IMG_HEIGHT, 3)`.
    The output layer should have `NUM_CATEGORIES` units, one for each category.
    """
    model = tf.keras.models.Sequential([
        # input layer
        tf.keras.layers.Conv2D(60, (3, 3), activation="relu", input_shape=(IMG_WIDTH, IMG_HEIGHT, 3)),
        tf.keras.layers.MaxPooling2D(pool_size=(2, 2)),
        tf.keras.layers.BatchNormalization(axis=2),

        tf.keras.layers.Conv2D(60, (3, 3), activation="relu", input_shape=(IMG_WIDTH, IMG_HEIGHT, 3)),
        tf.keras.layers.MaxPooling2D(pool_size=(3, 3)),
        tf.keras.layers.BatchNormalization(axis=2),

        tf.keras.layers.Conv2D(90, (2, 2), activation="relu", input_shape=(IMG_WIDTH, IMG_HEIGHT, 3)),
        # tf.keras.layers.MaxPooling2D(pool_size=(3, 3)),
        # tf.keras.layers.BatchNormalization(axis=2),
        tf.keras.layers.Dropout(0.4),

        tf.keras.layers.Flatten(),
        tf.keras.layers.Dense(50, activation="relu"),
        tf.keras.layers.Dense(120, activation="relu"),
        tf.keras.layers.Dropout(0.4),
        # output layer
        tf.keras.layers.Dense(NUM_CATEGORIES, activation="softmax")


#         tf.keras.layers.Conv2D(40, (5, 5), activation="relu", input_shape=(IMG_WIDTH, IMG_HEIGHT, 3)),
#         tf.keras.layers.Dropout(0.1),
#         tf.keras.layers.MaxPooling2D(pool_size=(2, 2)),
#         tf.keras.layers.Dropout(0.1),
#         tf.keras.layers.Conv2D(35, (3, 3), activation="relu", input_shape=(IMG_WIDTH, IMG_HEIGHT, 3)),
#         tf.keras.layers.Dropout(0.1),
#         tf.keras.layers.MaxPooling2D(pool_size=(2, 2)),
#         tf.keras.layers.Dropout(0.1),
#         tf.keras.layers.Flatten(),
#         # output layer
#         tf.keras.layers.Dense(NUM_CATEGORIES, activation="softmax")
    ])

    model.compile(
        optimizer="adam",
        loss="categorical_crossentropy",
        metrics=["accuracy"]
    )
    return model


if __name__ == "__main__":
    main()
