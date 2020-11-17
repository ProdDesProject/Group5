#!/usr/bin/env python

import numpy as np
import cv2 as cv
import json


def toJSON(arr):
    data = {}
    data['coins'] = []

    for i in arr[0, :]:
        data['coins'].append({
            "pos": {
                'x': float(i[0]),
                'y': float(i[1]),
                'r': float(i[2]),
            },
            'worth': None
        })
    data['sum'] = 0.0
    data['number of coins'] = arr.shape[1]

    with open('output_json.json', 'w') as outfile:
        json.dump(data, outfile, indent=4)

def resizeImage(img):

    scale_percent = 25  # percentage of original size
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height)
    # resize image
    resized = cv.resize(img, dim)

    return resized

def imgRead():
    print('Find coins')
#    img = cv.imread('inputs/coins_example.png', 0)
#    img = cv.imread('inputs/color_coins_example.jpg', 0)
    img = cv.imread('inputs/test/test_1.jpg',0)

    print('old size = ', img.shape)
    img = resizeImage(img)
    print('new size = ', img.shape)


    # blur of the picture
    blurImg = cv.medianBlur(img,5)

    # convert to gray colour
    cimg = cv.cvtColor(blurImg, cv.COLOR_GRAY2BGR)

#   ZALOHA
#    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=20, param1=90, param2=80, minRadius=0, maxRadius=0)
    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=40, param1=50, param2=50, minRadius=20, maxRadius=120)
    circles = np.uint16(np.around(circles))

#    print('Number of found coins:', circles.shape[1])
    for i in circles[0, :]:
        # draw the outer circle
        cv.circle(cimg, (i[0], i[1]), i[2], (0, 105, 0), 2)
        # draw the center of the circle
        cv.circle(cimg, (i[0], i[1]), 2, (0, 0, 255), 3)

    cv.imwrite('output.png',cimg)
    return circles

def main():

    circles = imgRead()
    toJSON(circles)

if __name__ == '__main__':
    main()
