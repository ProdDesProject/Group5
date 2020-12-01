import numpy as np
import sklearn
from sklearn.linear_model import SGDClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
import sklearn_json as skljson
import imageio
from PIL import Image
import glob
import pandas as pd

coin_types = {'1c', '2c', '5c', '10c', '20c', '50c', '1e', '2e'}

def main():
    """
    main method to create classifier
    """
    training_data_im, training_data_real = import_training_data()
    #testing_data_im, testing_data_real = import_testing_data()

    create_classifier(training_data_im, training_data_real)



def import_training_data():
    """ 
    load the training .jpg images from each folder and remember which coin it is
    """
    global coin_types
    coins_im = []
    coins_real = []
    maxShapeX = 0
    maxShapeY = 0

    for coin in coin_types:
        for im_path in glob.glob('./PDaI/original_split/train/' + coin + '/*.jpg'):
            image = np.array(Image.open(im_path).convert('L'))
            if image.shape[0] > maxShapeX:
                maxShapeX = image.shape[0]
            if image.shape[1] > maxShapeY:
                maxShapeY = image.shape[1]

    for coin in coin_types:
        for im_path in glob.glob('./PDaI/original_split/train/' + coin + '/*.jpg'):
            image = Image.open(im_path).convert('L')
            im_resize = image.resize((maxShapeX,maxShapeY))
            im_array = np.array(im_resize)
            im = im_array.flatten()
            coins_im.append(im)
            coins_real.append(coin)

    return coins_im, coins_real

def import_testing_data():
    """ 
    load the testing .jpg images from each folder and remember which coin it is
    """
    global coin_types
    coins_im = []
    coins_real = []
    maxShapeX = 0
    maxShapeY = 0

    for coin in coin_types:
        for im_path in glob.glob('./original_split/test/' + coin + '/*.jpg'):
            image = np.array(Image.open(im_path).convert('L'))
            if image.shape[0] > maxShapeX:
                maxShapeX = image.shape[0]
            if image.shape[1] > maxShapeY:
                maxShapeY = image.shape[1]

    for coin in coin_types:
        for im_path in glob.glob('./original_split/test/' + coin + '/*.jpg'):
            image = Image.open(im_path).convert('L')
            im_resize = image.resize((maxShapeX,maxShapeY))
            im_array = np.array(im_resize)
            im = im_array.flatten()
            coins_im.append(im)
            coins_real.append(coin)

    return coins_im, coins_real

def create_classifier(training_data_im, training_data_real):

    X_train = training_data_im
    y_train = training_data_real

    #play with param_grid to try out other combinations for classifier parameters
    #param_grid = [{'max_features': ["auto", "log2"], 'criterion': ["gini", "entropy"], 'oob_score': [True, False], 'random_state': [42, 37], 'n_jobs': [3, 4, 5], 'min_impurity_decrease': [0.01, 0.001, 0.0001]}]

    #forest_clf = RandomForestClassifier()
    #grid_search = GridSearchCV(forest_clf, param_grid, cv=5, verbose=3)
    #grid_search.fit(X_train, y_train)

    #print(grid_search.best_params_)
    #print(grid_search.best_score_)

    #parameters with best score for classifier
    #{'criterion': 'gini', 'max_features': 'auto', 'min_impurity_decrease': 0.001, 'n_jobs': 3, 'oob_score': True, 'random_state': 42}
    #0.5338775510204081
    clf = RandomForestClassifier(criterion='gini', max_features='auto', min_impurity_decrease=0.001, n_jobs=3, oob_score=True, random_state=42)
    clf.fit(X_train,y_train)

    #create best model from grid search and save it to json
    skljson.to_json(clf,'./classifier/classifier.json')

    print('Done!')

    return

if __name__ == '__main__':
    main()