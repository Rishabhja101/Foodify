import tensorflow as tf


def main():
    # converter = tf.lite.TFLiteConverter.from_saved_model('modelLoadCategorical.h5')
    # tflite_model = converter.convert()
    # open("modelLoadCategorical.tflite", "wb").write(tflite_model)

    # Convert the model.
    model = tf.keras.models.load_model('modelLoadCategorical.h5')

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()

    # Save the model.
    with open('model.tflite', 'wb') as f:
        f.write(tflite_model)


if __name__ == "__main__":
    main()