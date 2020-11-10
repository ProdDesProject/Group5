#!/usr/bin/env python

import numpy as np
import cv2 as cv


def imgRead():
    print('Find coins')
#    img = cv.imread('inputs/coins_example.png', 0)
    img = cv.imread('inputs/color_coins_example.jpg', 0)

    # blur of the picture
    blurImg = cv.medianBlur(img,5)

    # convert to gray colour
    cimg = cv.cvtColor(blurImg, cv.COLOR_GRAY2BGR)
#    cimg = cv.cvtColor(blurImg, cv.COLOR_BGR2GRAY)

    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, 20, param1=90, param2=80, minRadius=0, maxRadius=0)
    circles = np.uint16(np.around(circles))
    for i in circles[0, :]:
        # draw the outer circle
        cv.circle(cimg, (i[0], i[1]), i[2], (0, 105, 0), 2)
        #        # draw the center of the circle
        cv.circle(cimg, (i[0], i[1]), 2, (0, 0, 255), 3)

    cv.imwrite('output.png',cimg)

def main():
    imgRead()

if __name__ == '__main__':
    main()