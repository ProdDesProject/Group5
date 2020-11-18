#!/usr/bin/env python

import numpy as np
import cv2 as cv
import json
import os
import shutil

def cleanFiles():

    # Removing old cropped coins
    try:
        shutil.rmtree('cropped_coins')
    except OSError:
        print('Folder cropped_coins not found')

    os.mkdir('cropped_coins')

def circleCrop(coordinates,img, img_colour, cnt):
 #   img_colour = cv.imread('inputs/color_coins_example.jpg')

    CROP_RESERVE = 5
    x = coordinates[0]
    y = coordinates[1]
    r = coordinates[2]

    # Prepare the mask
    height, width = img.shape
    mask = np.zeros((height, width), np.uint8)
    # Draw on mask
    cv.circle(mask, (x, y), r+CROP_RESERVE, (255, 255, 255), thickness=-1)
    # Copy that image using that mask
    masked_data = cv.bitwise_and(img_colour, img_colour, None, mask=mask)
    # Crop masked_data
    crop = masked_data[y-r-CROP_RESERVE:y + r+CROP_RESERVE, x-r-CROP_RESERVE:x + r+CROP_RESERVE]

    # Writing the coin to .PNG with name and number
    outputString = 'cropped_coins/crop' + str(cnt) + '.png'
    cv.imwrite(outputString, crop)


def toJSON(arr):

    # Create JSON string/list/directory
    data = {}
    data['coins'] = []

    # Fill JSON object with data
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

    # Write JSON object to output
    with open('output_json.json', 'w') as outfile:
        json.dump(data, outfile, indent=4)


def resizeImage(img):

    scale_percent = 90  # percentage of original size
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height)
    # resize image
    resized = cv.resize(img, dim)

    return resized


def imgRead():

#    img = cv.imread('inputs/coins_example.png', 0)
#    img = cv.imread('inputs/test/test_1.jpg',0)

    picturePath = 'inputs/color_coins_example.jpg'
    img = cv.imread(picturePath, 0)
    img_colour = cv.imread(picturePath)

    print('old size = ', img.shape)
#    img = resizeImage(img)
    print('new size = ', img.shape)


    # blur of the picture (8 bit black/white)
    blurImg = cv.medianBlur(img,5)

    # convert to gray colour (24 bit b/w, support colouring the coins in output.png)
    cimg = cv.cvtColor(blurImg, cv.COLOR_GRAY2BGR)

#   ZALOHA
#    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=20, param1=90, param2=80, minRadius=0, maxRadius=0)
    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=70, param1=50, param2=50, minRadius=20, maxRadius=120)
    circles = np.uint16(np.around(circles))
#    print(circles)
    print('Number of found coins:', circles.shape[1])

    for idx, i in enumerate(circles[0, :]):
        # draw the outer circle
        cv.circle(cimg, (i[0], i[1]), i[2], (0, 105, 0), 2)
        # draw the center of the circle
        cv.circle(cimg, (i[0], i[1]), 2, (0, 0, 255), 3)
        # cut out the coin
        circleCrop(i,img, img_colour, idx+1)

    cv.imwrite('output.png',cimg)
    return circles

def main():

    cleanFiles()
    circles = imgRead()
    toJSON(circles)

if __name__ == '__main__':
    main()
