#!/usr/bin/env python

import os
import shutil
import glob
from datetime import datetime
from PIL import Image
from find_coins import main as fc
from classifier import prediction

def main():
    result = {
        'coins': [
        ],
    }
    
    base_path = os.path.join(os.path.dirname(__file__), 'tmp')
    file_path = os.path.join(base_path, datetime.now().strftime("%Y%m%d-%H%M%S"))
    
    if not os.path.exists(base_path):
        os.mkdir(base_path)
    if not os.path.exists(file_path):
        os.mkdir(file_path)
    
    img = Image.open('./find_coins/inputs/test/test_1.jpg')
    img.save(os.path.join(file_path, 'image.jpg'))

    try: 
        fc.findCircles(file_path)
    except Exception:
        shutil.rmtree(file_path)
        return result

    pre = prediction.Prediction()

    for im_path in glob.glob(os.path.join(file_path, '*.png')):
        image = pre.convert_image(im_path)
        predict_result = pre.predict(image)
        result['coins'].append(predict_result)

    
    shutil.rmtree(file_path)
    print(result)
    total = 0
    for item in result['coins']:
        total += item['worth']
    print(total)

if __name__ == '__main__':
    path = os.getcwd()
    if "PDaI" not in path:
        os.chdir('./PDaI')
    main()