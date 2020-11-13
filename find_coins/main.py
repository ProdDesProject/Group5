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


def imgRead():
    print('Find coins')
#    img = cv.imread('inputs/coins_example.png', 0)
    img = cv.imread('inputs/color_coins_example.jpg', 0)

    # blur of the picture
    blurImg = cv.medianBlur(img,5)

    # convert to gray colour
    cimg = cv.cvtColor(blurImg, cv.COLOR_GRAY2BGR)

    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=50, param1=30, param2=80, minRadius=20, maxRadius=120)
    circles = np.uint16(np.around(circles))
    for i in circles[0, :]:
        # draw the outer circle
        cv.circle(cimg, (i[0], i[1]), i[2], (0, 105, 0), 2)
        #        # draw the center of the circle
        cv.circle(cimg, (i[0], i[1]), 2, (0, 0, 255), 3)

    cv.imwrite('output.png',cimg)
    return circles

def main():

    circles = imgRead()
    toJSON(circles)

if __name__ == '__main__':
    main()