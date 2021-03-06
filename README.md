# Group5
## Coin Counter
App that recognizes the count of coins from a picture.
In addition, the app can recognize the worth of the coins and sum it up.

## Developers
* Andreas Scheipers <k0scan00@students.oamk.fi>
* Marek Fiala <k0fima00@students.oamk.fi>
* Max Winterberg <k0wima01@students.oamk.fi>

## Requirements

### Server
* \>= Python 3.6
* \>= 4 GB RAM

### App
* \>= Flutter 1.22

## Setup

### Server
```bash
git clone git@github.com:ProdDesProject/Group5.git coin-counter
cd coin-counter
python3 -m venv ./venv # If this does not work for you try: virtualenv venv -p python3.7
source venv/bin/activate
pip install -r requirements.txt
```

### App

```bash
# Check if Flutter installation is good.
flutter doctor
```

## Documentation

### Server

API server initial setup:
```bash
python manage.py migrate
python manage.py createsuperuser --email admin@example.com --username admin

export SECRET_KEY='xyz...'
export DEBUG=True
```

Start API server:
```bash
python manage.py runserver
```

API documentation: https://www.getpostman.com/collections/342b2847b575dbbc3b88

### App

Building the app:
```bash
# Android:
flutter build apk

#IOS:
flutter build ios
```
