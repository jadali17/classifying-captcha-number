import numpy as np
import cv2
from keras.utils import to_categorical
import os
import tensorflow as tf

def getImages():
    path = "imagedata/"
    listOfImages= []
    kernel = np.ones((3,3),np.uint8)
    for imageFileName in sorted(os.listdir(path)):

        img = cv2.imread(path+imageFileName,cv2.IMREAD_UNCHANGED)
        eroded = cv2.dilate(img, kernel, iterations = 1)
        cropped= eroded[50:140,70:200] #Getting rid of extra smudges
        
        #Divides every image into three seperate image containing most of each digit
        first = cropped [30:80,15:50]
        second = cropped [30:80,15+30:50+30]
        third = cropped [30:80,15+60:50+60]

        listOfImages.extend([first,second,third])

    listOfImages = np.array(listOfImages)
    listOfImages = listOfImages.reshape(listOfImages.shape[0],50,35,1)
    listOfimagesNorm = listOfImages.astype('float32')
    listOfimagesNorm = listOfimagesNorm  / 255.0 # Normalizing the image for the values to be between 1 and 0
    return listOfimagesNorm

def getLabels():
    listOfLabels = []
    with open('labels.txt') as fp:
        line = fp.readline()
        while line:
            parsedLine = line.replace(',', '').replace(" ", "").strip()
            listOfLabels.extend([int(i) for i in list(parsedLine)])
            line=fp.readline()
                    
    listOfLabels = np.array(listOfLabels)

    categories = tf.keras.utils.to_categorical(listOfLabels) #One hot encoding

    return categories
