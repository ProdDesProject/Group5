import numpy as np
import sklearn
from sklearn.linear_model import SGDClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
import sklearn_json as skljson
import pandas as pd
import imageio
from PIL import Image
import glob
import os, random


class Prediction:

    classifier = RandomForestClassifier()

    def __init__(self):
        global classifier
        #debug
        #classifier = skljson.from_json('./PDaI/classifier/classifier.json')
        #real
        classifier = skljson.from_json('./classifier/classifier.json')

    def predict(self, image):
        return classifier.predict(image)
    
    def convert_image(self, im_path):
        im = []
        image = Image.open(im_path).convert('L')
        im_resize = image.resize((502,502))
        im_array = np.array(im_resize)
        im.append(im_array.flatten())
        return im


def main():
    coin_types = {'1c', '2c', '5c', '10c', '20c', '50c', '1e', '2e'}
    pre = Prediction()
    for coin in coin_types:
        results = []
        for x in np.arange(10):
            #debug
            #folder = "./PDaI/original_split/test/"
            #real
            folder = "./original_split/test/" + coin + "/"
            file_name = random.choice(os.listdir(folder))
            image = pre.convert_image(folder + file_name)
            result = pre.predict(image)
            results.append(result)
        print(coin)
        print(results)

    #In the screenshot the result of testing the classifier can be seen. Each coin is tested 10 times with different pictures. The predictions are mostly correct.


if __name__ == '__main__':
    main()