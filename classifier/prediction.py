import numpy as np
import sklearn
from sklearn.linear_model import SGDClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
import sklearn_json as skljson
from PIL import Image
import glob
import os, random
import gzip

class Prediction:

    classifier = RandomForestClassifier()

    table = {}

    def __init__(self):
        """ 
        load the classifier
        """
        global classifier

        global table

        table = {
            '1c' : {'label': '0,01€', 'worth': 0.01}, 
            '2c' : {'label': '0,02€', 'worth': 0.02},
            '5c' : {'label': '0,05€', 'worth': 0.05},
            '10c' : {'label': '0,10€', 'worth': 0.10},
            '20c' : {'label': '0,20€', 'worth': 0.20},
            '50c' : {'label': '0,50€', 'worth': 0.50},
            '1e' : {'label': '1,00€', 'worth': 1.00},
            '2e' : {'label': '2,00€', 'worth': 2.00},
        }

        file_path = './classifier/classifier.json'
        if os.path.exists(file_path):
            os.remove(file_path)

        with gzip.open(file_path + '.gz', 'rb') as f:
            file_content = f.read()
            f = open(file_path, 'wb')
            f.write(file_content)
        
        classifier = skljson.from_json(file_path)

    def predict(self, image):
        """ 
        use an image to predict the coin, image has to be in the right format
        """
        global table
        
        coin = classifier.predict(image)
        amount = table[coin[0]]
        return amount
    
    def convert_image(self, im_path):
        """ 
        loads image and converts it into the right format for the classifier
        """
        im = []
        image = Image.open(im_path).convert('L')
        #502x502 is shape of pictures used to train the classifier
        im_resize = image.resize((628,628))
        im_array = np.array(im_resize)
        im.append(im_array.flatten())
        return im


def main():
    """ 
    test out the classifier, tries 10 different pictures for each coin type
    """
    coin_types = {'1c', '2c', '5c', '10c', '20c', '50c', '1e', '2e'}
    pre = Prediction()
    for coin in coin_types:
        results = []
        for x in np.arange(10):
            folder = "./original_split/test/" + coin + "/"
            file_name = random.choice(os.listdir(folder))
            image = pre.convert_image(folder + file_name)
            result = pre.predict(image)
            results.append(result)
        print(coin)
        print(results)


if __name__ == '__main__':
    path = os.getcwd()
    if "PDaI" not in path:
        os.chdir('./PDaI')
    main()