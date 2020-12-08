#!/usr/bin/env python

import numpy as np
import cv2 as cv
import json
import os
import shutil

# Delete folder with old cropped coins and create new one
def cleanFiles():

    # Removing old cropped coins
    try:
        shutil.rmtree('cropped_coins')
    except OSError:
        print('Folder cropped_coins not found')

    os.mkdir('cropped_coins')


# Crop all found coins and store them as png
def circleCrop(coordinates,img, img_colour, cnt, path):
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
    output_string = path + str(cnt) + '.png'
    cv.imwrite(output_string, crop)


# Create JSON file and fill the x,y,r parameters
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

# Linear stretching of pixels
def linear_stretching(input, lower_stretch_from, upper_stretch_from):

    # lower value of the range to stretch to - output
    lower_stretch_to = 0  
    # upper value of the range to stretch to - output
    upper_stretch_to = 255

    output = (input - lower_stretch_from) * ((upper_stretch_to - lower_stretch_to) / (upper_stretch_from - lower_stretch_from)) + lower_stretch_to

    return output


# Gamma correction of picture - restore the contrast in the faded image using linear stretching
def gamma_correction(img):

#    img = cv.imread('inputs/test/test_1.jpg', 0)

    # Max and min value of image pixels
    max_value = np.max(img)
    min_value = np.min(img)

    # Cycle - linear stretching formula on each pixel
    for y in range(len(img)):
        for x in range(len(img[y])):
            img[y][x] = linear_stretching(img[y][x], min_value, max_value)

#    cv.imwrite('gamma_correction.png', img)
    return img


# Resizing the image in some scale
def resizeImage(img):

    # percentage of original size
    scale_percent = 50
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height)

    # resize image
    resized = cv.resize(img, dim)

    return resized

# Finding circles in the picture
def findCircles(picturePath):

#    img = cv.imread('inputs/coins_example.png', 0)
#    img = cv.imread('inputs/test/test_1.jpg',0)
# inputs/my_coins1.jpg
# 'inputs/color_coins_example.jpg'
#'inputs/test/test_1.jpg'

    # Input picture
    full_path = os.path.join(picturePath, 'image')
    img = cv.imread(full_path, 0)
    img_colour = cv.imread(full_path)

    # convert to gray colour (24 bit b/w, support colouring the out-lines of the coins in output.png)
    output_img = cv.cvtColor(img, cv.COLOR_GRAY2BGR)

    # Change the size of the immages
#    print('old size = ', img.shape)
    img = resizeImage(img)
    img_colour = resizeImage(img_colour)
    output_img = resizeImage(output_img)
#    print('new size = ', img.shape)

    # Gamma correction
    img = gamma_correction(img)

    # blur of the picture (8 bit black/white)
    blurImg = cv.medianBlur(img,15)
#    cv.imwrite('blur_output.png', blurImg)

#   ZALOHA
#    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=20, param1=90, param2=80, minRadius=0, maxRadius=0)
    circles = cv.HoughCircles(blurImg, cv.HOUGH_GRADIENT, 1, minDist=50, param1=50, param2=50, minRadius=50, maxRadius=180) #""",minRadius=20, maxRadius=120""")
    if circles is None:
        raise Exception('No circles found.')
    circles = np.uint16(np.around(circles))

    # sorting 3-D array due 1st axis
    circles2D = circles[0]
    circles = circles2D[circles2D[:, 0].argsort()]
    circles = circles[np.newaxis, ...]

    print('Number of found coins:', circles.shape[1])

    for idx, i in enumerate(circles[0, :]):
        # draw the outer circle
        cv.circle(output_img, (i[0], i[1]), i[2], (0, 105, 0), 2)
        # draw the center of the circle
        cv.circle(output_img, (i[0], i[1]), 2, (0, 0, 255), 3)
        # cut out the coin
        circleCrop(i,img, img_colour, idx+1, picturePath)

    # cv.imwrite('output.png',output_img)
    os.remove(full_path)

    return circles

def main():

    cleanFiles()
    circles = findCircles()
    toJSON(circles)

if __name__ == '__main__':
    main()
