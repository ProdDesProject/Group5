#!/usr/bin/env python

import glob
from find_coins import main as fc
from classifier import prediction

def main():
    print('Coin Counter')

    fc.cleanFiles()
    circles = fc.findCircles()
    fc.toJSON(circles)
    pre = prediction.Prediction()

    for im_path in glob.glob('./find_coins/cropped_coins/*.png'):
        image = pre.convert_image(im_path)
        predict_result = pre.predict(image)
        print(predict_result)

if __name__ == '__main__':
    main()