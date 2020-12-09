import os
import glob
import shutil
from datetime import datetime
from find_coins import main as fc
from classifier import prediction


def count_coins(img: bytes):
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


    f = open(os.path.join(file_path, 'image.jpg'), 'wb')
    f.write(img)
    f.close()

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

    return result
