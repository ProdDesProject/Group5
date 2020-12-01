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

    def __init__(self):
        """ 
        load the classifier
        """
        global classifier

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
        return classifier.predict(image)
    
    def convert_image(self, im_path):
        """ 
        loads image and converts it into the right format for the classifier
        """
        im = []
        image = Image.open(im_path).convert('L')
        #502x502 is shape of pictures used to train the classifier
        im_resize = image.resize((502,502))
        im_array = np.array(im_resize)
        im.append(im_array.flatten())
        return im


def main():
    """ 
    test out the classifier, tries 10 different pictures for each coin type
    """
    coin_types = {'1c', '2c', '5c', '10c', '20c', '50c', '1e', '2e'}
    pre = Prediction()
    path = os.getcwd()
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