import operator
import random

import numpy as np
import cv2
import tensorflow as tf
import streamlit as st
from PIL import Image, ImageOps
import streamlit.components.v1 as components

st.set_option('deprecation.showfileUploaderEncoding', False)


def classifier():
    with open('filename') as f:
        lines = f.readlines()
    foodDict = {}
    for line in lines:
        temp = line.split()
        foodDict[temp[0]] = temp[1]
    new_model = tf.keras.models.load_model('modelLoadWITHTRASH.h5')
    img = cv2.imread("temp.jpg")
    resized_image = cv2.resize(img, (30, 30))
    img = np.reshape(resized_image, (1, 30, 30, 3))
    predictions = new_model.predict(img)
    pred = np.array_str(predictions)
    temp2 = []
    dictValues = {}
    for num in pred.split():
        value = ''
        for char in num:
            if char != '[' and char != ']':
                value += char
        if value != '':
            temp2.append(float(value))
    for x in range(len(foodDict)):
        dictValues[x] = temp2[x]
    sorted_d = sorted(dictValues.items(), key=operator.itemgetter(1), reverse=True)
    print(sorted_d)
    classification = sorted_d[0][0]
    st.write(foodDict.get(classification))


st.title('Foodify')
st.header('Classify your food with us today!')
st.subheader('Foodify uses neural networks to figure out what food you are looking at!')
st.write("")

components.html(
    """<img class="recycle-img" src="https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500" alt="recycle-img" 
    styles="height:250px; width:250px; padding:2rem;"> 
    """,
    height=250, width=500
)
st.header('Please upload an image file')
file = st.file_uploader("", type=["jpg", "png", 'jpeg'])

if file is None:
    st.text("")
else:
    image = Image.open(file)
    image.save("temp.jpg")
    st.image(image, width=300)
    classifier()

# streamlit run classifier.py


